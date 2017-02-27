//
//  Conductor.swift
//  SoundFont
//
//  Created by Chris Mendez on 10/22/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//
import AudioKit
import Firebase

class Conductor {
    
    var sampler = AKSampler()
    var currentSoundBank = Config.defaultSoundBank
    
    var server:Server?
    
    init() {
        //print("Conductor.init", soundFontSample)
        loadSoundFont(soundBank: currentSoundBank)
        
        //Connect to Output
        AudioKit.output = sampler
        AudioKit.start()
    }
    
    //MARK: - Performance
    func play(note: Int, velocity: Int, duration: Float){
        //print("Conductor.play")
        sampler.play(noteNumber: note, velocity: velocity, channel: 0)
    }
    
    func loadSoundFont(soundBank:Soundbank){
        let soundFont = soundBank.audio
        
        sampler.loadMelodicSoundFont((soundFont?.0)!, preset: (soundFont?.1)!)
    }
}
