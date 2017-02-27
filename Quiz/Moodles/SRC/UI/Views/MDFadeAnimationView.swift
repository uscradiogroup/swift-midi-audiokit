//
//  BackgroundAnimationView.swift
//  Moodles
//
//  Created by VladislavEmets on 11/25/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class MDFadeAnimationView: UIView, CAAnimationDelegate {

    fileprivate var currentItemIndex: Int = 0
    fileprivate var animation: CATransition?
    fileprivate var currentItem: UIImage?
    fileprivate var active: Bool = true
    
    fileprivate let items = [
        UIImage.init(imageLiteralResourceName: "Pad1"),
        UIImage.init(imageLiteralResourceName: "Pad2"),
        UIImage.init(imageLiteralResourceName: "Pad3"),
        UIImage.init(imageLiteralResourceName: "Pad4"),
        UIImage.init(imageLiteralResourceName: "Pad5")
    ]
    
    fileprivate let durations = [
        3.0,
        4.0,
        5.0,
        6.0
    ]
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func display(_ layer: CALayer) {
        layer.contents = items.randomElement().cgImage
        layer.contentsGravity = kCAGravityResize;
        if animation == nil {
                self.startNextAnimation()
        }
    }
    
    
    @objc private func startNextAnimation() {
        active = true
        var nextItem = currentItem
        repeat {
            nextItem = items.randomElement()
        } while(currentItem == nextItem)
        currentItem = nextItem
        
        animation = CATransition()
        animation?.startProgress = 0.0
        animation?.endProgress = 1.0
        animation?.type = kCATransitionFade
        let time = durations.randomElement()
        animation?.duration = time
        animation?.isRemovedOnCompletion = false
        animation?.delegate = self
        layer.add(animation!, forKey: "transition")
        layer.contents = nextItem?.cgImage
        layer.contentsGravity = kCAGravityResize;
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            startNextAnimation()
    }

}
