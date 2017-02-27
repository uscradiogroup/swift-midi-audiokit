//
//  UIView+Extension.swift
//  Moodles
//
//  Created by VladislavEmets on 11/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var innerCenter: CGPoint {
        get {
            return CGPoint(x: self.frame.width / 2,
                           y: self.frame.height / 2)
        }
    }
    
    
    static func fromNib<T : UIView, U : UIViewController>(owner: U?) -> T? {
        let name = String(describing: self)
        guard let view = Bundle.main.loadNibNamed(name, owner: owner, options: nil)?.first as? T
            else {
            return nil
        }
        return view
    }
    
    
    func layoutSubviewsRecursively () {
        for view in self.subviews {
            view.layoutSubviews()
            view.layoutSubviewsRecursively()
        }
    }
    
}
