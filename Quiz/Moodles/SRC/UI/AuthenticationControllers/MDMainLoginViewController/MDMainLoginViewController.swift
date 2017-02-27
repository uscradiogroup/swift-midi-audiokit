//
//  MDAuthenticationViewController.swift
//  Moodles
//
//  Created by Sergey Kulikov on 1/12/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import TwitterKit
import FacebookLogin
import FacebookCore

class MDMainLoginViewController: UIViewController, ViewControllerRootView {

    typealias RootViewType = MDMainLoginView
    private var loading: ActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.withSlider()?.enableShortcut(false)
        loading = ActivityView.activityView()
    }
    
    // MARK: -  IBActions

    @IBAction func onSignIn(_ sender: AnyObject) {
        if let signController = UIStoryboard.fromMainBundle(named: MDStoryboards.authentication).instantiateViewController(describedByType: MDSignInViewController.self) {
            pushEmailController(withNext: signController)
        }
    }
    
    @IBAction func onSignUp(_ sender: AnyObject) {
        if let signController = UIStoryboard.fromMainBundle(named: MDStoryboards.authentication).instantiateViewController(describedByType: MDSignUpViewController.self)  {
            pushEmailController(withNext: signController)
        }
    }
    
    @IBAction func onBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBackToRecord(_ sender: Any) {
        navigationController?.withSlider()?.enableShortcut(true)
        backToRecord()
    }
    
    @IBAction func onFacebookLogin() {
        loading?.showActivityViewOn(view: rootView)
        LoginManager().logIn([ .publicProfile ], viewController: self) { [weak self] loginResult in
            switch loginResult {
            case .success( _, _, let accessToken):
                let facebookCredential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self?.firebaseAuth(with: facebookCredential)
            case.failed(let error):
                self?.loading?.hideActivityView()
                self?.presentAlert(message: error.localizedDescription)
            case.cancelled:
                self?.loading?.hideActivityView()
                print("Cancelled")
            }
        }
    }
    
    @IBAction func onTwitterLogin() {
        Twitter.sharedInstance().logIn {  [weak self] session, error in
            if (session != nil) {
                let twitterCredential = FIRTwitterAuthProvider.credential(withToken: session!.authToken,
                                                                          secret: session!.authTokenSecret)
                self?.firebaseAuth(with: twitterCredential)
            } else {
                self?.presentAlert(message: error?.localizedDescription ?? "Filed to sign in")
            }
        }
    }
    
    // MARK: -  Privat Methods
    
    private func pushEmailController<T>(withNext controller: T)
        where T:UIViewController, T:MDEmailInjectionProtocol
    {
        guard let emailController = storyboard?.instantiateViewController(describedByType: MDEmailViewController.self) else {
            return
        }
        emailController.onVerifyEmail = {
            (email: String, navigation: UINavigationController?) in
            controller.email = email
            navigation?.pushViewController(controller, animated: true)
        }
        navigationController?.pushViewController(emailController, animated: true)
    }
    
    private func firebaseAuth(with credential: FIRAuthCredential) {
        loading?.showActivityViewOn(view: rootView)
        FIRAuth.auth()?.signIn(with: credential) { [weak self] (user, authError) in
            if let signError = authError {
                self?.presentAlert(message: signError.localizedDescription)
            } else {
                self?.navigationController?.popToRootViewController(animated: true)
            }
            self?.loading?.hideActivityView()
        }
    }
    
}
