//
//  MDQuizView.swift
//  Moodles
//
//  Created by VladislavEmets on 2/10/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

class MDQuizView: PadView {
    
    @IBOutlet weak var viewReady: UIView!
    @IBOutlet weak var buttonReady: UIButton!
    @IBOutlet weak var viewDemonstration: UIView!
    
    
    func showReadyScreen(show: Bool) {
        viewReady.isHidden = !show
    }
    
    func showDemonstrationScreen(show: Bool) {
        viewDemonstration.isHidden = !show
    }
    
}
