//
//  PadView.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/13/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit


class PadView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonStopRecord: UIButton!
    @IBOutlet weak var labelTimeleft: UILabel!
    @IBOutlet weak var viewAnimations: MDSquallAnimationView!
    private var activity: UIActivityIndicatorView?
    
    // MARK: -  IBActions
    
    // MARK: -  Overriden methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activity = UIActivityIndicatorView()
        activity?.hidesWhenStopped = true
    }

    
    // MARK: -  Public methods
    
    func startRecording() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.buttonStopRecord.alpha = 1
                        self.labelTimeleft.alpha = 1
                        self.layoutSubviews()
        })
    }
    
    func stopRecording() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.buttonStopRecord.alpha = 0
                        self.labelTimeleft.alpha = 0
                        self.labelTimeleft.text = "0:60"
        })
    }
    
    func playAnimation(index: Int, tapPoint:CGPoint) {
        viewAnimations.playAnimation(index: index, point: tapPoint)
    }
    
    func updateRecordedTime (_ time: TimeInterval) {
        labelTimeleft.alpha = 1.0
        let string: String = time.shortString()
        labelTimeleft.text = string
    }
    
    func showActivity(show: Bool) {
        if (activity == nil) {return}
        
        if show && activity?.superview == nil {
            activity?.frame = self.bounds
            addSubview(activity!)
            activity?.startAnimating()
        } else {
            activity?.stopAnimating()
            activity?.removeFromSuperview()
        }
    }
    
}


extension TimeInterval {
    func shortString() -> String {
        var string: String? = ""
        let timeDate = Date(timeIntervalSinceReferenceDate: self)
        let calendar = Calendar.current
        let dateComponents: Set<Calendar.Component> = [Calendar.Component.minute, Calendar.Component.second]
        let components = calendar.dateComponents(dateComponents, from: timeDate)
        var secondsString = String(describing: components.second!)
        if components.second! < 10 {
            secondsString = "0"+secondsString
        }
        string?.append(String(describing: components.minute!))
        string?.append(":")
        string?.append(secondsString)
        return string!
    }
}
