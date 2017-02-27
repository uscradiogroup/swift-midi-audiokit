//
//  MDEnsembleSyncronizer.swift
//  Moodles
//
//  Created by VladislavEmets on 1/18/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation
import MagicalRecord
import Ensembles

let CDEICloudFileSystemDidDownloadFilesNotification = "CDEICloudFileSystemDidUpdateFilesNotification"
let CDEMonitoredManagedObjectContextDidSaveNotification = "CDEMonitoredManagedObjectContextDidSaveNotification"


class MDEnsembleSyncronizer: NSObject, CDEPersistentStoreEnsembleDelegate {
    
    private var ensemble: CDEPersistentStoreEnsemble?
    private var cloudFileSystem: CDEICloudFileSystem?
    
    // MARK: -  Class methods
    
    static let shared : MDEnsembleSyncronizer = {
        let instance = MDEnsembleSyncronizer()
        return instance
    }()
    
    
    // MARK: -  Initializations

    deinit {
        unsubscribeSyncNotification()
    }
    
    private override init() {
        super.init()
        subscribeSyncNotification()
    }
    
    
    // MARK: -  Public methods
    
    @objc func synchronize(_ completion: ((Error?)->Void)?) {
        if ensemble?.isLeeched == false {
            ensemble?.leechPersistentStore(completion: {[weak self] (error) in
                completion?(error)
                if error == nil {
                    self?.synchronize(nil)
                }
            })
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.ensemble?.merge(completion: { (error) in
                    completion?(error)
                })
            }
        }
    }
    
    
    func attachTo(context moContext:NSManagedObjectContext?, store storeURL: URL) {
        cloudFileSystem = CDEICloudFileSystem(ubiquityContainerIdentifier: MDEnsemble.ICloudContainerIdentifier)
        let modelURL = Bundle.main.url(forResource: "Moodles", withExtension: "momd")
        if FileManager.default.fileExists(atPath: modelURL!.path) == false {
            print ("File do not exist")
        }
        if FileManager.default.fileExists(atPath: storeURL.path) == false {
            print ("File do not exist")
        }
        ensemble = CDEPersistentStoreEnsemble(ensembleIdentifier: MDEnsemble.identifier,
                                              persistentStore: storeURL,
                                              managedObjectModelURL: modelURL,
                                              cloudFileSystem: cloudFileSystem!)
        ensemble?.delegate = self
    }
    
    
    // MARK: -  Private methods
    
    private func subscribeSyncNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(privateSync), name: CDEICloudFileSystemDidDownloadFilesNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(privateSync), name: CDEMonitoredManagedObjectContextDidSaveNotification)
    }
    
    @objc func privateSync() {
        synchronize(nil)
    }
    
    private func unsubscribeSyncNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -  CDEPersistentStoreEnsembleDelegate
    
    func persistentStoreEnsemble(_ ensemble: CDEPersistentStoreEnsemble!,
                                 didSaveMergeChangesWith notification: Notification!) {
        let rootContext = NSManagedObjectContext.mr_rootSaving()
        rootContext.perform {
            rootContext.mergeChanges(fromContextDidSave: notification)
        }
        let mainContext = NSManagedObjectContext.mr_default()
        mainContext.perform {
            mainContext.mergeChanges(fromContextDidSave: notification)
            NotificationCenter.default.postWith(name: MDNotification.Name.ensembleDidSync)
        }
    }
    
}
