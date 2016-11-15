//
//  Utils.swift
//  MP3AF
//
//  Created by Chris Mendez on 9/25/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static let sharedInstance = Utils()
    fileprivate init() {} //This prevents others from using the default '()' initializer for this class.
    
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(arc4random() % 255) / 255.0
        let blueValue = CGFloat(arc4random() % 255) / 255.0
        let greenValue = CGFloat(arc4random() % 255) / 255.0
        
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 0.5)
    }
    
    func callBlockAfter(_ block : @escaping ()->(), duration : Double) {
        let delayTime = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { () -> Void in
            block()
        })
    }
}
