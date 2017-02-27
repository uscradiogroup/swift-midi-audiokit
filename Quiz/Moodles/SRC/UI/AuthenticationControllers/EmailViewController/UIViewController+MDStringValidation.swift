//
//  UIViewController+MDStringValidation.swift
//  Moodles
//
//  Created by VladislavEmets on 2/1/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

extension UIViewController {
    func validate(string: String?, using validator: StringValidator) -> Bool {
        guard let string = string else {
            return false
        }
        let (valid, error) = validator.validate(string)
        if let error = error {
            presentAlert(message: error.localizedDescription)
            return valid
        }
        return true
    }
}
