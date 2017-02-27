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
    
    class func activityView() -> ActivityView? {
        let nib = Bundle.main.loadNibNamed("ActivityView", owner: self, options: nil)
        let view = nib?.first as? ActivityView
        return view
    }
    
    static func showOn(view: UIView) -> ActivityView? {
        let activityView = ActivityView.activityView()
        activityView?.showActivityViewOn(view: view)
        return activityView
    }

    // MARK: - Public methods
 
    func showActivityViewOn(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        let views = ["view": self]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                                   options: NSLayoutFormatOptions(rawValue: UInt(0)),
                                                                                   metrics: nil,
                                                                                   views: views)
        view.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
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
