//
//  AVFoundationFunctions.swift
//  Moodles
//
//  Created by VladislavEmets on 1/5/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation
import AVFoundation


func enablePlaybackInSilentMode() {
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
    }
    catch {
        print("AVAudioSession::error:")
    }
}
