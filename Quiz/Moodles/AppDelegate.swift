//
//  AppDelegate.swift
//  Moodles
//
//  Created by Tommy Trojan on 11/4/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import Mixpanel
import FirebaseCore
import FirebaseAuth
import Fabric
import TwitterKit
import Crashlytics
import SwiftyStoreKit
import Branch
import FacebookCore
import Ensembles


enum MDNavigationState {
    case nonlogined
    case logined
}


@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ListenloopPresenterSource {

    var window: UIWindow?
    
    private let listenloop = ListenloopPresenter()
    private let mainStoryboard = UIStoryboard.init(name: MDStoryboards.main, bundle: Bundle.main)
    private let authStoryboard = UIStoryboard.init(name: MDStoryboards.authentication, bundle: Bundle.main)
    
    private let kAuthNavigationController = "AuthenticationNavigationController"
    private let kTwitterConsumer = "tnXBUZ6g7gk0enJMRvMiTifvA"
    private let kTwitterSecret = "q6l7EQPDsOPtg2ZB7qNZ0t0qsTHTTCqviRUX53SsY3ANXIdtAl"
    
    
    // MARK: -  Public methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupLibraries(application, launchOptions)
        setupCoredata()
        
        self.window?.rootViewController = mainStoryboard.instantiateViewController(describedByType: MDNavigationController.self)
        
        listenloop.delegate = self;
        listenloop.showOverlayIsAvailable()
        enablePlaybackInSilentMode()
        return true
    }
    
    // MARK: -  Private methods
    
    private func setupLibraries (_ application: UIApplication,_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FIRApp.configure()
        Twitter.sharedInstance().start(withConsumerKey: kTwitterConsumer,
                                       consumerSecret: kTwitterSecret)
        Fabric.with([Branch.self, Twitter.self])
        
        //DEEP LINKS
        let deeplinkHandler: callbackWithParams = { [weak self] (parameters, error) in
            if error == nil,
                let musicID = parameters?[MDDeeplink.MetaKey.filename],
                let musicFolder = parameters?[MDDeeplink.MetaKey.folder],
                parameters?.keys.contains(MDDeeplink.MetaKey.referrer) == false
            {
                self?.showRecordingsTab()
                NotificationCenter.default.postWith(name: MDNotification.Name.openFIRStorageFile,
                                                    userInfo: [MDNotification.Key.musicName : musicID, MDNotification.Key.musicFolder : musicFolder])
            } else {
                print(error ?? "no error")
            }
        }
        Branch.getInstance().initSession(launchOptions: launchOptions,
                                         andRegisterDeepLinkHandler: deeplinkHandler)
        
        
        //PURCHASES
        SwiftyStoreKit.completeTransactions(atomically: true) { products in
            for product in products {
                if product.transaction.transactionState == .purchased ||
                    product.transaction.transactionState == .restored {
                    if product.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                    print("purchased: \(product)")
                }
            }
        }
        
        SwiftyStoreKit.retrieveProductsInfo(["purchase1"], completion: { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if result.invalidProductIDs.count > 0 {
                print(result.invalidProductIDs)
            }
            else {
                print("Error: \(result.error)")
            }
        })
        
        //ANALYTICS
        let mixpanel = Mixpanel.initialize(token: MDMixpanel.token)
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            mixpanel.identify(distinctId:uuid)
            mixpanel.people.set(properties: [
                MDMixpanel.Property.userId : uuid,
                MDMixpanel.Property.lastLogin : Date()
                ])
        }
        
        //FACEBOOK
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupCoredata() {
        MagicalRecord.setShouldAutoCreateManagedObjectModel(false)
        let mom = NSManagedObjectModel.mr_newManagedObjectModelNamed("Moodles.momd")
        NSManagedObjectModel.mr_setDefaultManagedObjectModel(mom)
        MagicalRecord.setupAutoMigratingCoreDataStack()

//        MDEnsembleSyncronizer.shared.attachTo(context: NSManagedObjectContext.mr_default(),
//                                              store: NSPersistentStore.mr_default()!.url!)
//        MDEnsembleSyncronizer.shared.synchronize(nil)
    }

    private func tryOpenMidiFile(_ url: URL) {
        if url.scheme == MDURLScheme.file &&
            (url.pathExtension == MDFileSystem.Extension.mid ||
                url.pathExtension == MDFileSystem.Extension.midi) {
            if let fileUrl = (url as NSURL).filePathURL {
                _ = parse(fileUrl: fileUrl).then(execute: {
                    music -> Void in
                    self.showRecordingsTab()
                    NotificationCenter.default.postWith(name: MDNotification.Name.openSharedMidiFile)
                })
            }
        }
    }
    
    
    private func tryOpenApplicationLink(_ url: URL) {
        guard url.scheme == MDURLScheme.moodles,
            url.host == MDURLScheme.Host.resetPass else {
                return
        }
        let parameters = url.queryParameters()
        if let mail = parameters[MDURLScheme.Key.mail],
           let code = parameters[MDURLScheme.Key.resetCode] {
            showResetPasswordFor(email: mail, code)
        }
    }
    
    
    private func showRecordingsTab() {
        if let mdNavigation = self.window?.rootViewController as? MDNavigationController {
            mdNavigation.switchTo(screen: MDRootScreen.Recordings)
        }
    }
    
    
    private func showResetPasswordFor(email: String, _ code: String) {
        if let mdNavigation = self.window?.rootViewController as? MDNavigationController,
            let resetViewController = authStoryboard.instantiateViewController(describedByType: MDRestoreViewController.self),
            let signViewController = authStoryboard.instantiateViewController(describedByType: MDMainLoginViewController.self){
            mdNavigation.switchTo(screen: .More)
            resetViewController.email = email
            resetViewController.resetCode = code
            mdNavigation.pushViewController(signViewController, animated: false)
            mdNavigation.pushViewController(resetViewController, animated: false)
        }
    }
    
    // MARK: -  UIApplicationDelegate
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        let branch = Branch.getInstance()
        if let result = branch?.continue(userActivity) {
            return result
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        tryOpenMidiFile(url)
        tryOpenApplicationLink(url)
        
        if Branch.getInstance().handleDeepLink(url) {
            print(url)
        }
        if Twitter.sharedInstance().application(app, open:url, options: options) {
            return true
        }
        if SDKApplicationDelegate.shared.application(app, open: url, options: options) {
            return true
        }
        
        return true
    }
        
    func applicationDidBecomeActive(_ application: UIApplication) {
        Mixpanel.mainInstance().time(event: MDMixpanel.Event.sessionTime)
        AppEventsLogger.activate(application)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Mixpanel.mainInstance().track(event: MDMixpanel.Event.sessionTime)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func presentationControllerFor(presenter: ListenloopPresenter) -> UIViewController? {
        return window?.rootViewController
    }
    
}

extension AppDelegate {
    class func shared() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
}
