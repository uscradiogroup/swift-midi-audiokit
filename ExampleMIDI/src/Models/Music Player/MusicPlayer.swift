//
//  Conductor.swift
//  SequencerDemo
//
//  Created by Kanstantsin Linou on 6/30/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import AudioKit

class MusicPlayer {
    private let midi = AKMIDI()
    
    private let oscillator = AKFMOscillatorBank()
    
    private let sound: AKMIDINode
    
    private let mixer: AKMixer

    private var sequence = AKSequencer()
    
    private(set) var music: Music? = nil
    
    var isPlaying : Bool {
        var playing = self.sequence.isPlaying
        
        if let music = self.music where playing == true {
            let currentPosition = self.sequence.currentPosition
            playing = AKDuration(beats: music.length) > currentPosition
        }
        
        return playing
    }
    
    // MARK: - init adn deinit
    
    init() {
        AudioKit.stop()
        self.sound = AKMIDINode(node: oscillator)
        self.sound.enableMIDI(midi.client, name: "sound")
        self.mixer = AKMixer(sound)
        AudioKit.output = self.mixer
        sequence.setTempo(60)
    }
    
    convenience init(music: Music) {
        self.init()
        self.music = music
        setupTracksFromMusic(music)
    }
    
    convenience init(filename: String) {
        self.init()
        self.sequence = AKSequencer(filePath: filename)
    }
    
    // MARK - Public functions
    
    func play(music music: Music) {
        self.music = music
        self.sequence.stop()
        self.sequence = AKSequencer()
        self.sequence.setTempo(60)
        setupTracksFromMusic(music)
        self.play()
    }
    
    func preparePlayer() {
        AudioKit.start()
    }

    func play() {
        sequence.play()
    }
    
    func stop() {
        sequence.stop()
    }
    
    // MARK: - Private functions
    
    private func setupTracksFromMusic(music: Music) {
        let tracks = music.tracks as? Set<Track>
        
        tracks?.enumerate().forEach({ (index: Int, track: Track) in
            let musicTrack = sequence.newTrack()!
            musicTrack.setLength(AKDuration(beats: track.length))
            let events = track.events as? Set<NoteEvent>
            events?.forEach { (note: NoteEvent) in
                musicTrack.add(noteNumber: Int(note.number),
                    velocity: MIDIVelocity(note.velocity),
                    position: AKDuration(beats: note.time),
                    duration: AKDuration(beats: note.duration))
            }
            musicTrack.setMIDIOutput((self.sound.midiIn))
        })
    }
}
