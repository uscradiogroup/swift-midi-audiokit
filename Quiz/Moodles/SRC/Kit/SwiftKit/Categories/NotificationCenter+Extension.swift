//
//  NSNotification+Extension.swift
//  Moodles
//
//  Created by VladislavEmets on 1/12/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

extension NotificationCenter {
    
    func postWith(name named: String, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        self.post(name: NSNotification.Name(rawValue: named), object: object, userInfo: userInfo)
    }
    
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: String) {
        self.addObserver(observer, selector: aSelector, name: NSNotification.Name(rawValue: aName), object: nil)
    }
    
}
