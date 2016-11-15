//
//  Conductor.swift
//  SoundFont
//
//  Created by Tommy Trojan on 10/19/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//
import AudioKit

class Conductor {
 
    var sampler = AKSampler()
    var soundFont:String?
    
    init(path:String) {
        print("Conductor.init", path)
        sampler.loadMelodicSoundFont(path, preset: 0)
        
        AudioKit.output = sampler
        AudioKit.start()
    }

    func play(note: Int, velocity: Int, duration: Float){
        //print("Conductor.play")
        sampler.play(noteNumber: note, velocity: velocity, channel: 0)
    }
}
