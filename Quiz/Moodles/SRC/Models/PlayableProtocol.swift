//
//  MDPlayable.swift
//  Moodles
//
//  Created by VladislavEmets on 1/24/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

protocol Playable {
    func play()
    func stop()
    var isPlaying: Bool {get}
}
