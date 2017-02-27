//
//  MDSignUpViewController.swift
//  Moodles
//
//  Created by Sergey Kulikov on 1/12/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import UIKit

class MDSignUpViewController: UIViewController, ViewControllerRootView, MDEmailInjectionProtocol {

    typealias RootViewType = MDSignView
    
    var email: String?
    
    // MARK: -  IBActions
    
    @IBAction func onCreateUser(_ sender: Any) {
        createUser(email: email, password: rootView.textFiledPass.text)
    }
    
    @IBAction func onBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -  Private Methods
    
    private func createUser(email: String?, password: String?) {
        if !validate(string: password, using: MDPassValidator()) {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { [weak self]  (user, error) in
            if error != nil {
                self?.presentAlert(message: error!.localizedDescription)
            } else {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}


