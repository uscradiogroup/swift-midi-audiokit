//
//  TimelineObserver.swift
//  Moodles
//
//  Created by VladislavEmets on 12/30/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

class TimelineObserver {
    
    private var timer: Timer?
    
    func observeTimeOf<T:Timeline & Playable>(object: T,
                       frequency: TimeInterval,
                       call: @escaping (TimeInterval, TimeInterval, Bool) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true, block: { timer in
            call(object.currentTime, object.duration, object.isPlaying)
        })
    }
    
    func removeObserving() {
        timer?.invalidate()
    }
    
}
