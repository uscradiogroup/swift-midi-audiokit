//
//  MDMetronomeProbe.swift
//  Moodles
//
//  Created by VladislavEmets on 1/4/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import AudioKit


class MDSingleMetronome: Playable {
    
    private let mixer: AKMixer
    private let pumper: AKCompressor
    private var metronome: MDMetronome

    var isPlaying: Bool {
        return self.metronome.isPlaying
    }
    
    // MARK: - init and deinit
    
    deinit {
        metronome.stop()
    }
    
    init(settings: MDMetronomeUserSettings, metronomeSource: Soundbank.Audio) {
        AudioKit.stop()
        metronome = MDMetronome(settings: settings, audio: metronomeSource)
        mixer = AKMixer()
        pumper = AKCompressor(mixer)
        AudioKit.output = pumper
        AudioKit.start()
        mixer.connect(metronome.sampler)
        metronome.prepare()
    }
    
    // MARK: - Public
    
    func play() {
        enablePlaybackInSilentMode()
        metronome.play()
    }

    func stop() {
        metronome.stop()
    }
    
    func changeVolume(_ volume: Double) {
        metronome.volume = volume
    }
    
    func changeBeats(_ beats: Double) {
        metronome.beats = beats
    }

}
