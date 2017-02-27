//
//  Double+Extension.swift
//  Moodles
//
//  Created by VladislavEmets on 12/6/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

infix operator ./ : AdditionPrecedence

extension Double {
    
    func short(_ decimalsAfterPoint: Double) -> Double {
        let multiplier = Double(pow(10, decimalsAfterPoint))
        let greater = Double(multiplier * self)
        let newValue = Double(greater.rounded() / multiplier)
        return newValue
    }
    
    func toInt(_ catchDecimalsAfterPoint: Double) -> Int {
        let multiplier = Double(pow(10, catchDecimalsAfterPoint))
        let result = Int(self * multiplier)
        return result
    }
    
    static func ./ (lhs: Double, rhs: Double) -> Double {
        return lhs.short(rhs)
    }
    
}
