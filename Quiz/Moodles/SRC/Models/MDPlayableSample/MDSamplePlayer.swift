//
//  MDPlayableSample.swift
//  Moodles
//
//  Created by VladislavEmets on 1/24/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

class MDSamplePlayer {
    
    private let player: Playable
    private var timer: Timer?
    
    deinit {
        stop()
    }
    
    // MARK: -  Initializations

    init(player: Playable) {
        self.player = player
    }
    
    // MARK: -  Public methods
    
    func play(duration time:TimeInterval) {
        guard timer == nil else {
            return
        }
        player.play()
        timer = Timer.scheduledTimer(withTimeInterval: time,
                                     repeats: false,
                                     block: { [weak self] (firedTimer) in
            self?.stop()
        })
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        player.stop()
    }
    
    // MARK: -  Private methods
    
}
