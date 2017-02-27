//
//  UserDefaults+Extension.swift
//  Moodles
//
//  Created by VladislavEmets on 1/24/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    func synchronize<T: Comparable>(value:T,
                     forKey key: String,
                     minValue min: T,
                     withDefault defaultValue: T) -> T {
        var synced = value
        if synced < min {
            synced = defaultValue
        }
        self.set(synced, forKey: key)
        self.synchronize()
        return synced
    }
    
}
