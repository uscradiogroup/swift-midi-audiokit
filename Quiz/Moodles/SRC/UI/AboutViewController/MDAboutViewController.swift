//
//  MDAboutViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 11/17/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit

class MDAboutViewController: UIViewController {
    
    @IBAction func onBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBackToRecord(_ sender: Any) {
        backToRecord()
    }
    
    
}
