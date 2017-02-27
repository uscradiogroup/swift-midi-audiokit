//
//  MDEmailValidator.swift
//  Moodles
//
//  Created by VladislavEmets on 1/5/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

class MDEmailValidator: StringValidator {
    
    func validate(_ string: String) -> (Bool, Error?) {
        var error: Error?
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: string)
        if !valid {
            error = NSError(domain: "",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey : "Invalid email format"])
        }
        return (valid, error)
    }
    
}
