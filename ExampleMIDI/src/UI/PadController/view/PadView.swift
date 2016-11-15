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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playStopButton: UIButton!
    @IBOutlet weak var listButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateTitles(false)
    }
    
    func record(recording: Bool) {
        self.updateTitles(recording)
        self.listButton.enabled = !recording
    }
    
    private func updateTitles(recording: Bool) {
        self.playStopButton.setTitle(recording ? "Stop" : "Start", forState: .Normal)
        self.titleLabel.text = recording ? "Press \"Stop\" to stop Record" : "Press \"Start\" to Record"
    }
}
