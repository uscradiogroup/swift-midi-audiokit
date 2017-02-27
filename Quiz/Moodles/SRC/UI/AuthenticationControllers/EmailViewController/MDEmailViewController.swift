//
//  MDEmailViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 2/1/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

class MDEmailViewController: UIViewController, ViewControllerRootView {
    
    typealias RootViewType = MDEmailView
    
    var onVerifyEmail:((String, UINavigationController?)->Void)?
    
    // MARK: -  Class methods
    
    // MARK: -  Initializations
    
    // MARK: -  LifecicleViewController
    
    // MARK: -  IBActions
    
    @IBAction func onBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onVerifyEmail(_ sender: Any) {
        if let email = rootView.textFieldEmail.text?.trimmingWhitespacesAndNewlines(),
            validate(string: email, using: MDEmailValidator()) {
            onVerifyEmail?(email, self.navigationController)
        }
    }
    
    // MARK: -  Overriden methods
    
    // MARK: -  Public methods
    
    // MARK: -  Private methods
    
}
