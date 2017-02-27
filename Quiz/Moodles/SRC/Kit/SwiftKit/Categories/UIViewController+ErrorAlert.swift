//
//  UIViewController+ErrorAlert.swift
//  Moodles
//
//  Created by VladislavEmets on 1/6/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func presentAlert(message: String,
                      title: String = "",
                      confirm text: String = "Ok",
                      handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: text, style: .cancel, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func presentDeleteDialog(message: String,
                             delete labelDelete: String,
                             cancel labelCancel: String,
                             title: String = "",
                             handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: labelCancel, style: .cancel))
        alert.addAction(UIAlertAction(title: labelDelete, style: .destructive, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alertWithTextField(title: String,
                            message: String?,
                            placeholder:String?,
                            cancel: String,
                            confirm: String,
                            onConfirm: @escaping (String?) -> Void,
                            onCancel: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okButton = UIAlertAction(title: confirm, style: .default, handler: { (action) in
            onConfirm(alertController.textFields?.first?.text)
        })
        let cancelButton = UIAlertAction(title: cancel, style: .cancel, handler: { (action) in
            onCancel?()
        })
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        alertController.preferredAction = okButton
        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
        }
        
        return alertController
    }
    
}
