//
//  UIViewController+RootView.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewControllerRootView {
    
    associatedtype RootViewType
    
    var rootView: RootViewType { get }
}

public extension ViewControllerRootView where Self : UIViewController {
    
    var rootView: RootViewType {
        return self.view as! RootViewType
    }
    
}
