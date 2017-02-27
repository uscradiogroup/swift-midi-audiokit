//
//  String+Extension.swift
//  Moodles
//
//  Created by VladislavEmets on 1/6/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

infix operator /+ : AdditionPrecedence

extension String {
    
    func trimmingWhitespacesAndNewlines() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func reducedTo(length: Int) -> String {
        if self.characters.count > length {
            let range = self.startIndex..<self.characters.index(self.startIndex, offsetBy: length)
            let reduced = self[range]
            return reduced
        }
        return self
    }
    
    static func /+ (lhs: String, rhs: String) -> String {
        return lhs + "/" + rhs
    }
    
}
