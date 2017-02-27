//
//  UIStoryboard+Extension.swift
//  Moodles
//
//  Created by VladislavEmets on 12/1/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit


extension UIStoryboard {
    
    static func fromMainBundle(named name:String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
    
    ///Method to instantiate view controller which storyboard identifier is same as it's type
    ///
    func instantiateViewController<T:UIViewController> (describedByType controllerType: T.Type) -> T? {
        let viewController = instantiateViewController(withIdentifier: String(describing: controllerType)) as? T
        return viewController
    }
    
}
