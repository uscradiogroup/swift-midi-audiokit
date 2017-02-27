//
//  MDRestoreViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 2/2/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

class MDRestoreViewController: UIViewController, ViewControllerRootView {
    
    typealias RootViewType = MDRestoreView
    let loading = ActivityView.activityView()
    var email = ""
    var resetCode = ""

    // MARK: -  LifecicleViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.labelTitle.text = "for " + email
    }
    
    // MARK: -  IBActions
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onResetPass(_ sender: Any) {
        if let pass = rootView.textFieldPassword.text,
            MDPassValidator().validate(pass).0 == true {
            loading?.showActivityViewOn(view: rootView)
            FIRAuth.auth()?.confirmPasswordReset(withCode: resetCode,
                                                 newPassword: pass,
                                                 completion:
                { [weak self] (error) in
                    self?.loading?.hideActivityView()
                    if let error = error {
                        self?.presentAlert(message: error.localizedDescription)
                    } else {
                        self?.presentAlert(message: "",
                                           title: "Pass was chaged",
                                           confirm: "Ok", handler:
                            { (action) in
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
            })
        }
    }
    
    // MARK: -  Overriden methods
    
    // MARK: -  Public methods
    
    // MARK: -  Private methods
    
}
