//
//  StringValidator.swift
//  Moodles
//
//  Created by VladislavEmets on 1/5/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

protocol StringValidator {
    func validate(_ string: String) -> (Bool, Error?)
}
