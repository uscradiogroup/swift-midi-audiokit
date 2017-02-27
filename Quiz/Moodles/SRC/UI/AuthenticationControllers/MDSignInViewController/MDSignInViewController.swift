//
//  MDSignInViewController.swift
//  Moodles
//
//  Created by Sergey Kulikov on 1/12/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import UIKit
import PromiseKit


class MDSignInViewController: UIViewController, ViewControllerRootView, MDEmailInjectionProtocol {
    
    typealias RootViewType = MDSignView
    
    var email: String?
    
    // MARK: -  IBActions
    
    @IBAction func onBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        loginUser(email: email, password: rootView.textFiledPass.text)
    }
    
    @IBAction func onForgotPassword(_ sender: Any) {
        let onReset = { [weak self] (string: String?) -> Void in
            guard let mail = string else {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: mail, completion: { (error) in
                if let error = error {
                    self?.presentAlert(message: error.localizedDescription)
                }
            })
        }
        
        let alertController = alertWithTextField(title: "Forgot Your Password?",
                                                 message: "Please confirm your e-mail and we'll send you instructions for resetting your password.",
                                                 placeholder: "Email address",
                                                 cancel: "Cancel",
                                                 confirm: "Send",
                                                 onConfirm: onReset)
        alertController.textFields?.first?.keyboardAppearance = UIKeyboardAppearance.dark
        alertController.textFields?.first?.text = email
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: -  Private Methods
    
    private func loginUser(email: String?, password: String?) {
        if !validate(string: password, using: MDPassValidator()) {
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { [weak self]  (user, error) in
            if error != nil {
                self?.presentAlert(message: error!.localizedDescription)
            } else {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

}
