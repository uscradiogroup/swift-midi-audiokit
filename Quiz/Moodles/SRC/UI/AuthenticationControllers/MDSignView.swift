//
//  SignView.swift
//  Moodles
//
//  Created by VladislavEmets on 1/16/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import UIKit

class MDSignView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var textFiledPass: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
