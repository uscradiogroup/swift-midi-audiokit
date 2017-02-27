//
//  MDPassValidator.swift
//  Moodles
//
//  Created by VladislavEmets on 1/5/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

class MDPassValidator: StringValidator {
    
    func validate(_ string: String) -> (Bool, Error?) {
        var error: Error?
        let valid = string.characters.count > 4
        if !valid {
            error = NSError(domain: "",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey : "Password is too short"])
        }
        return (valid, error)
    }
    
    
}
