//
//  MDBackgroundAnimator.swift
//  Moodles
//
//  Created by VladislavEmets on 1/20/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit


protocol MDBackgroundAnimatorDelegate: class {
    func animationsContainer() -> UIView?
}


class MDBackgroundAnimator {
    
    weak var delegate: MDBackgroundAnimatorDelegate?
    
    private weak var viewBackgroundAnimationsTop: MDFadeAnimationView?
    private weak var viewBackgroundAnimationsBottom: MDFadeAnimationView?
    private var lastOrientation: UIDeviceOrientation
    
    
    private var view: UIView? {
        get {
            return self.delegate?.animationsContainer()
        }
    }
    
    // MARK: -  Initializations
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        removeAnimations()
    }
    
    init(delegate: MDBackgroundAnimatorDelegate) {
        self.delegate = delegate
        lastOrientation = UIDevice.current.orientation
        setupBackgroundAnimations()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(restartAnimation),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }
    
    // MARK: -  Public methods
    
    func removeAnimations() {
        viewBackgroundAnimationsTop?.removeFromSuperview()
        viewBackgroundAnimationsBottom?.removeFromSuperview()
    }
    
    // MARK: -  Private methods
    
    @objc private func restartAnimation() {
        let newOrientation = UIDevice.current.orientation
        if lastOrientation.isFlat == false &&
            newOrientation.isFlat == false &&
            newOrientation != lastOrientation
        {
            removeAnimations()
            setupBackgroundAnimations()
        }
        lastOrientation = newOrientation
    }
    
    private func setupBackgroundAnimations() {
        func addAnimationView() -> MDFadeAnimationView? {
            if let view = self.view {
                let viewAnimation = MDFadeAnimationView()
                viewAnimation.frame = view.bounds
                view.addSubview(viewAnimation)
                view.sendSubview(toBack: viewAnimation)
                viewAnimation.fitConstraintsToSuperview(container: view)
                return viewAnimation
            }
            return nil
        }
        viewBackgroundAnimationsTop = addAnimationView()
        viewBackgroundAnimationsBottom = addAnimationView()
    }
    
}
