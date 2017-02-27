//
//  Config.swift
//  Moodles
//
//  Created by VladislavEmets on 11/25/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import AudioKit

let kSoundfontExtension = "sf2"

//This will be the unit we use to sell more in-app purchases
struct Soundbank {
    typealias Audio = (soundfont:String, preset:Int)
    var audio: Audio
    var animations: [String]
}

struct Config {
    private struct squall{
        static let license = "SQL*cmendez*kuscDOTorg*595fdc2a9302c9299f51fc4e73cc07fd36a9ae1eaf3ef15a578dd15b9a333d43ad3de04334b292aa49567395bb37aba74480756947255b2d461d53a817a47ca6c1a4aaf64cbea369fc39d06d0a9d3eeb23819832867be5a661ef6e5687c32cd3d9dcfcdb7a448c29bb4a0b107cddba8f565ddf31692b69329bddc4aa615e99ff*SUL2"
    }
    
    static let metronome = (soundfont: "media/audio/metronome", preset: 0)
    
    // This is the default Soundbank that comes with the app
    static let defaultSoundBank = Soundbank(
        audio: (soundfont: "media/audio/AcousticGuitar", preset: 0),
        animations: [
            "media/animations/2_0/01.sqa", "media/animations/2_0/02.sqa",
            "media/animations/2_0/03.sqa", "media/animations/2_0/04.sqa",
            "media/animations/2_0/05.sqa", "media/animations/2_0/06.sqa",
            "media/animations/2_0/07.sqa", "media/animations/2_0/08.sqa",
            "media/animations/2_0/09.sqa", "media/animations/2_0/10.sqa",
            "media/animations/2_0/11.sqa", "media/animations/2_0/12.sqa",
            "media/animations/2_0/13.sqa", "media/animations/2_0/14.sqa",
            "media/animations/2_0/15.sqa", "media/animations/2_0/16.sqa",
            "media/animations/2_0/17.sqa", "media/animations/2_0/18.sqa",
            "media/animations/2_0/19.sqa", "media/animations/2_0/20.sqa",
            "media/animations/2_0/21.sqa", "media/animations/2_0/22.sqa",
            "media/animations/2_0/23.sqa", "media/animations/2_0/24.sqa"
        ]
    )
    
    // This is the default Soundbank that comes with the app
    static let pianoSoundBank = Soundbank(
        audio: (soundfont: "media/audio/Piano", preset: 0),
        animations: [
            "media/animations/2_0/01.sqa", "media/animations/2_0/02.sqa",
            "media/animations/2_0/03.sqa", "media/animations/2_0/04.sqa",
            "media/animations/2_0/05.sqa", "media/animations/2_0/06.sqa",
            "media/animations/2_0/07.sqa", "media/animations/2_0/08.sqa",
            "media/animations/2_0/09.sqa", "media/animations/2_0/10.sqa",
            "media/animations/2_0/11.sqa", "media/animations/2_0/12.sqa",
            "media/animations/2_0/13.sqa", "media/animations/2_0/14.sqa",
            "media/animations/2_0/15.sqa", "media/animations/2_0/16.sqa",
            "media/animations/2_0/17.sqa", "media/animations/2_0/18.sqa",
            "media/animations/2_0/19.sqa", "media/animations/2_0/20.sqa",
            "media/animations/2_0/21.sqa", "media/animations/2_0/22.sqa",
            "media/animations/2_0/23.sqa", "media/animations/2_0/24.sqa"
        ]
    )
    
    static let orchestraSoundBank = Soundbank(
        audio: (soundfont: "media/audio/Orchestra", preset: 0),
        animations: [
            "media/animations/2_0/01.sqa", "media/animations/2_0/02.sqa",
            "media/animations/2_0/03.sqa", "media/animations/2_0/04.sqa",
            "media/animations/2_0/05.sqa", "media/animations/2_0/06.sqa",
            "media/animations/2_0/07.sqa", "media/animations/2_0/08.sqa",
            "media/animations/2_0/09.sqa", "media/animations/2_0/10.sqa",
            "media/animations/2_0/11.sqa", "media/animations/2_0/12.sqa",
            "media/animations/2_0/13.sqa", "media/animations/2_0/14.sqa",
            "media/animations/2_0/15.sqa", "media/animations/2_0/16.sqa",
            "media/animations/2_0/17.sqa", "media/animations/2_0/18.sqa",
            "media/animations/2_0/19.sqa", "media/animations/2_0/20.sqa",
            "media/animations/2_0/21.sqa", "media/animations/2_0/22.sqa",
            "media/animations/2_0/23.sqa", "media/animations/2_0/24.sqa"
        ]
    )
}
