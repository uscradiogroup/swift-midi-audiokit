//
//  SquallAnimationView.swift
//  Moodles
//
//  Created by VladislavEmets on 11/25/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit
import Squall


class MDSquallAnimationView: UIView {
    
    private var animations:[SLCoreAnimation] = []
    var animationsNames = Config.pianoSoundBank.animations {
        didSet {
            setupAnimations()
        }
    }
    
    //MARK: - Overriden
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAnimations()
    }
    
    //MARK: - Public
    
    func playAnimation(index: Int, point:CGPoint) {
        if (index >= animations.count) { return }

        let animation = animations[index]
        if animation.isPaused() {
            self.layer.addSublayer(animation)
        } else {
            animation.time = 0
        }
        
        animation.position = point
        animation.play()
        animation.onAnimationEvent = { event in
            if event == .end {
                animation.time = 0
                animation.removeFromSuperlayer()
            }
        }
    }
    
    //MARK: - Private
    
    private func setupAnimations () {
        animations.removeAll()
        for (idx, item) in animationsNames.enumerated() {
            let animation = SLCoreAnimation(fromBundle: item)!
            animation.name = String(idx)
            animations.append(animation)
        }
    }


}
