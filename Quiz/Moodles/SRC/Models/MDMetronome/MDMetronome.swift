//
//  MDMetronome.swift
//  Moodles
//
//  Created by VladislavEmets on 11/21/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import AudioKit

enum MDSequence: Int {
    case metronome = 0
}


class MDMetronome: Playable {
        
    let sampler: AKMIDISampler
    private let midi: AKMIDI
    private let audio: Soundbank.Audio
    private let sequenceLength = AKDuration(beats: 1.0)
    private let sequence: AKSequencer = AKSequencer()
    private var tempo: MDMetronomeTempo
    
    var beats: Double {
        didSet {
            sequence.setTempo(beats)
        }
    }
    
    var volume: Double {
        didSet {
            sampler.volume = volume
        }
    }
    
    var isPlaying: Bool {
        return self.sequence.isPlaying
    }
    
    // MARK: -  Initialization

    init(beats: Double, tempo: MDMetronomeTempo, volume: Double, audio: Soundbank.Audio) {
        AudioKit.stop()
        _ = sequence.newTrack()
        sampler = AKMIDISampler()
        midi = AKMIDI()
        self.audio = audio
        self.tempo = tempo
        self.beats = beats
        self.volume = volume
        sequence.setTempo(beats)
        sampler.volume = volume
    }
    
    convenience init(settings: MDMetronomeSettings, audio: Soundbank.Audio) {
        self.init(beats: settings.bpm, tempo: settings.tempo, volume: settings.volume, audio: audio)
    }
    
    // MARK: -  Public methods

    func play() {
        sequence.enableLooping()
        sequence.play()
    }
    
    func stop() {
        sequence.stop()
    }
    
    // MARK: -  Private methods
    
    /// Call this method only after you connect sampler to mixer node
    ///
    func prepare() {
        sampler.loadMelodicSoundFont(audio.soundfont, preset: audio.preset)
        sampler.enableMIDI(midi.client, name: String(describing: type(of: self)))
        generateBassDrumSequence()
        sequence.enableLooping()
        sequence.setTempo(beats)
        sampler.volume = volume
    }
    
    private func generateBassDrumSequence(_ stepSize: Float = 1, clear: Bool = true) {
        sequence.tracks[MDSequence.metronome.rawValue].clear()
        let numberOfSteps = Int(Float(sequenceLength.beats)/stepSize)
        for i in 0 ..< numberOfSteps {
            let step = Double(i) * stepSize
            sequence.tracks[MDSequence.metronome.rawValue].add(noteNumber: 60, //FIXME: strange numbers
                                                               velocity: 127,
                                                               position: AKDuration(beats: step),
                                                               duration: AKDuration(beats: 1))
            sequence.tracks[MDSequence.metronome.rawValue].setMIDIOutput(sampler.midiIn)
        }
    }
    
    private func changeTempo (tempo: MDMetronomeTempo) {
        
    }
    
}
