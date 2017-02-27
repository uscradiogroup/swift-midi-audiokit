//
//  NSError+Extension.swift
//  Moodles
//
//  Created by VladislavEmets on 1/12/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

extension NSError {
    
    static let ApplicationErrorDomain = "ApplicationErrorDomain"
    
    convenience init(described reason: String) {
        self.init(domain: NSError.ApplicationErrorDomain,
                  code: 0,
                  userInfo: [NSLocalizedDescriptionKey:reason])
    }
    
}
