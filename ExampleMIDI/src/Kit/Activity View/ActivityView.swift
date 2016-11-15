//
//  ActivityView.swift
//  SwiftKit-UI
//
//  Created by Artem Chabannyi on 9/27/16.
//  Copyright © 2016 IDAP Group. All rights reserved.
//

import UIKit

class ActivityView: UIView {

    @IBOutlet var backgroundActivityView: UIView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Class methods
    
    static func activityView() -> ActivityView {
        let view: ActivityView = NSBundle.mainBundle().loadNibNamed("ActivityView", owner: self, options: nil)?.first as! ActivityView
        return view
    }
    
    static func showOn(view view: UIView) -> ActivityView {
        let activityView: ActivityView = ActivityView.activityView()
        activityView.showActivityViewOn(view: view)
        return activityView
    }

    // MARK: - Public methods
 
    func showActivityViewOn(view view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        let views = ["view": self]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
                                                                                   options: NSLayoutFormatOptions(rawValue: UInt(0)),
                                                                                   metrics: nil,
                                                                                   views: views)
        view.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
                                                                               options: NSLayoutFormatOptions(rawValue: UInt(0)),
                                                                               metrics: nil,
                                                                               views: views)
        view.addConstraints(verticalConstraints)
        
        self.activityIndicatorView.startAnimating()
    }
    
    func hideActivityView() {
        self.removeFromSuperview()
        self.activityIndicatorView.stopAnimating()
    }
}
