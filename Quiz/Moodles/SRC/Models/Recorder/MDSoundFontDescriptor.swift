//
//  MDSoundFontDescriptor.swift
//  Moodles
//
//  Created by VladislavEmets on 11/29/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import AudioKit

class MDSoundFontDescriptor {
    
    fileprivate let soundfontUrl: URL
    
    // MARK: -  Initializations

    init(soundfontUrl: URL) {
        self.soundfontUrl = soundfontUrl
    }
    
    // MARK: -  Public methods
    
    func durationOf(note: MIDINoteNumber) -> TimeInterval {
        return 5
    }
    
    // MARK: -  Private methods
    
}
