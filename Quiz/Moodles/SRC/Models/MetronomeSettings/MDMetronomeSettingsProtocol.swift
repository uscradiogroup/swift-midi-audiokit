//
//  MDMetronomeSettingsProtocol.swift
//  Moodles
//
//  Created by VladislavEmets on 11/22/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

enum MDMetronomeTempo: Int {
    case standard4d4 = 0
    case waltz3d4
}

protocol MDMetronomeSettings {
    var enabled: Bool {get}
    var bpm: Double {get}
    var volume: Double {get}
    var tempo: MDMetronomeTempo {get}
}

struct MDDefaultMetronomeSettings {
    static let bpm = 60.0
    static let minVolume = 0.4
    static let volume = 0.9
}
