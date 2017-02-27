//
//  MDBottomSlider.swift
//  Moodles
//
//  Created by VladislavEmets on 11/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class MDBottomSlider: UIView {
    
    @IBOutlet weak var viewSliderShortcut:      UIButton!
    @IBOutlet weak var constraintPanHeight:     NSLayoutConstraint!
    @IBOutlet weak var constraintPanWidth:      NSLayoutConstraint!
    @IBOutlet weak var buttonLeft:              UIButton!
    @IBOutlet weak var buttonCenter:            UIButton!
    @IBOutlet weak var buttonRight:             UIButton!
    @IBOutlet weak var buttonHide:              UIButton!
    @IBOutlet weak var imageViewWheel:          UIImageView!

    private weak var owner: UIViewController?
    private var sizeVisible = CGSize(width: 0, height: 0)
    
    private lazy var viewBlure: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
        view.alpha = 0.6
        return view
    }()
    
    
    var visible: Bool = true
    var constraintWidth: Constraint?
    var constraintHeight: Constraint?
    
    var sizeHidden: CGSize {
        return CGSize(width: constraintPanWidth.constant,
                      height:constraintPanHeight.constant)
    }
    
    
    //MARK: - Init
    
    static func setupOn(viewController: UIViewController) -> MDBottomSlider? {
        guard let wheel = MDBottomSlider.fromNib(owner: viewController) as? MDBottomSlider else {
            return nil
        }
        wheel.owner = viewController
        wheel.sizeVisible = wheel.frame.size
        viewController.view.addSubview(wheel)
        wheel.snp.makeConstraints({ [weak viewController] (make) in
            wheel.constraintWidth = make.width.equalTo(wheel.frame.size.width).constraint
            wheel.constraintHeight = make.height.equalTo(wheel.frame.size.height).constraint
            if let selfView = viewController?.view {
                make.bottom.equalTo(selfView).offset(0)
                make.centerX.equalTo(selfView).offset(0)
            }
        })
        return wheel
    }
    
    
    //MARK: - Public methods
    
    func setVisible(visible: Bool, animated: Bool) {
        setVisible(visible: visible, animated: animated, animation: nil)
    }
    
    
    func setVisible(visible: Bool, animated: Bool, animation: (() -> Swift.Void)?) {
        guard let sliderOwner = owner, self.visible != visible else {
            return
        }
        
        self.visible = visible
        
        if let animationBlock = animation {
            UIView.animate(withDuration: animated ? 0.3 : 0.0,
                           animations: animationBlock,
                           completion: { finish in
                            self.viewBlure.removeFromSuperview()
            })
        } else {
            if visible {
                viewSliderShortcut.alpha = 0
                imageViewWheel.alpha = 1
                viewBlure.alpha = 0
                viewBlure.frame = sliderOwner.view.bounds
                sliderOwner.view.insertSubview(viewBlure, belowSubview: self)
                viewBlure.fitConstraintsToSuperview(container: sliderOwner.view)
            }
            UIView.animate(withDuration: animated ? 0.35 : 0.0,
                           animations: {
                            let slider = self
                                let size = visible ? slider.sizeVisible : slider.sizeHidden
                                slider.constraintWidth?.update(offset: size.width)
                                slider.constraintHeight?.update(offset: size.height)
                                
                                slider.buttonRight.alpha = visible ? 1 : 0
                                slider.buttonCenter.alpha = visible ? 1 : 0
                                slider.buttonLeft.alpha = visible ? 1 : 0
                                slider.buttonHide.alpha = visible ? 1 : 0
                            
                                slider.viewBlure.alpha = visible ? 0.35 : 0
                                slider.layoutSubviewsRecursively()
                                sliderOwner.view.layoutSubviews()
            }, completion: { finish in
                if !visible {
                    self.viewSliderShortcut.alpha = 1
                    self.imageViewWheel.alpha = 0
                    self.viewBlure.removeFromSuperview()
                }
            })
        }

    }

    
    func setupButtonsImages(left: String, center: String, right: String) {
        buttonLeft.setImage(UIImage.init(named: left), for: .normal)
        buttonCenter.setImage(UIImage.init(named: center), for: .normal)
        buttonRight.setImage(UIImage.init(named: right), for: .normal)
    }
    
    //MARK: - Extensions
}


extension UIView {
    func fitConstraintsToSuperview(container: UIView) {
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(container).offset(0)
            make.top.equalTo(container).offset(0)
            make.left.equalTo(container).offset(0)
            make.right.equalTo(container).offset(0)
        }
    }
}
