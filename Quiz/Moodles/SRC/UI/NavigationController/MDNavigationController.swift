//
//  MDNavigationController.swift
//  Moodles
//
//  Created by VladislavEmets on 11/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit


class MDNavigationController:
UINavigationController,
UINavigationControllerDelegate,
MDBackgroundAnimatorDelegate {
    
    private var viewSlider: MDBottomSlider? = nil
    private weak var sliderDelegate: MDNavigationProtocol?

    private lazy var backgroundAnimator: MDBackgroundAnimator = {
        [unowned self] in
        return MDBackgroundAnimator(delegate: self)
    }()
    
    var sliderIsVisible: Bool {
        return viewSlider?.visible ?? false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -  Overriden methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBottomSlider()
        sliderDelegate = self.viewControllers.first as? MDNavigationProtocol
        viewSlider?.setVisible(visible: false, animated: false)
    }
    
    
    // MARK: -  Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openFIRStorageFile(notification:)),
                                               name: MDNotification.Name.openFIRStorageFile)
        _ = backgroundAnimator
    }
    
    @objc func openFIRStorageFile(notification: Notification) {
        guard let firFileName = notification.userInfo?[MDNotification.Key.musicName] as? String,
            let firFileFodler = notification.userInfo?[MDNotification.Key.musicFolder] as? String else {
                return
        }
        self.switchTo(screen: .Recordings)
        self.sliderDelegate?.showMusicFromFIRShare(fromFolder: firFileFodler, named: firFileName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubview(toFront: viewSlider!)
    }
    
    // MARK: -  IBActions
    
    @IBAction func onSwipeSliderDown(_ sender: AnyObject) {
        viewSlider?.setVisible(visible: false, animated: true)
    }
    
    @IBAction func onTapSliderShorcut(_ sender: AnyObject) {
        viewSlider?.setVisible(visible: true, animated: true)
    }
    
    @IBAction func onHideSlider(_ sender: AnyObject) {
        viewSlider?.setVisible(visible: false, animated: true)
    }
    
    
    @IBAction func onMenuLeft(_ sender: AnyObject) {
        switchTo(screen: .Recordings)
        viewSlider?.setVisible(visible: false, animated: true)
    }
    
    @IBAction func onMenuCenter(_ sender: AnyObject) {
        let delegateDidHandleAction = sliderDelegate?.handleCenterItemPressed()
        if delegateDidHandleAction == false {
            switchTo(screen: .Record)
            viewSlider?.setVisible(visible: false, animated: true)
        }
    }
    
    @IBAction func onMenuRight(_ sender: AnyObject) {
        switchTo(screen: .More)
        viewSlider?.setVisible(visible: false, animated: true)
    }
    
    
    // MARK: -  Public methods
    
    open func switchTo(screen: MDRootScreen) {
        let identifier: String = screen.rawValue
        let toViewController = storyboard?.instantiateViewController(withIdentifier: identifier)
        
        if let controller = toViewController as? MDNavigationProtocol {
            self.setViewControllers([toViewController!], animated: true)
            sliderDelegate = controller
        }
    }

    
    func hideSliderAndShortcut (animated: Bool) {
        viewSlider?.setVisible(visible: false, animated: animated, animation: {
            if let slider = self.viewSlider {
                let size = slider.sizeHidden
                slider.constraintWidth?.update(offset: size.width)
                slider.constraintHeight?.update(offset: size.height)
                slider.buttonRight.alpha = 0
                slider.buttonCenter.alpha = 0
                slider.buttonLeft.alpha = 0
                slider.buttonHide.alpha = 0
                slider.viewSliderShortcut.alpha = 0
                slider.layoutSubviewsRecursively()
            }
            self.view.layoutSubviews()
        })
    }

    
    func makeShortcutVisible (_ visible: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0.0,
                       animations: {
                        self.viewSlider?.viewSliderShortcut.alpha = visible ? 1 : 0
        })
    }
    
    func enableShortcut(_ enable: Bool) {
        viewSlider?.viewSliderShortcut.isUserInteractionEnabled = enable
    }
    
    // MARK: -  Private methods
    
    private func setupBottomSlider() {
        viewSlider = MDBottomSlider.setupOn(viewController: self)
        viewSlider?.setupButtonsImages(left: styleForSliderItem(item: .Recordings),
                                 center: styleForSliderItem(item: .Record),
                                 right: styleForSliderItem(item: .More))
    }
    
    private func styleForSliderItem(item: MDRootScreen) -> String {
        switch item {
        case .Recordings:
            return "SliderButtonRecords"
        case .Record:
            return "SliderButtonRecord"
        case .More:
            return "SliderButtonMore"
        default:
            return ""
        }
    }

    
    // MARK: -  UINavigationControllerDelegate
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation:
        UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        return MDFadeInAnimator()
    }
    
    
    // MARK: -  MDBackgroundAnimatorDelegate
    
    func animationsContainer() -> UIView? {
        return self.view
    }
    
    
    // MARK: -  Extensions
}


extension UINavigationController {
    func withSlider () -> MDNavigationController? {
        return self as? MDNavigationController
    }
}


extension UIViewController {
    func backToRecord() {
        self.navigationController?.withSlider()?.switchTo(screen: .Record)
    }
}
