//
//  Conductor.swift
//  SequencerDemo
//
//  Created by Kanstantsin Linou on 6/30/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import AudioKit

typealias BlockOnNoteEvent = (MIDINoteNumber)->Void


class MusicPlayer <Composition>: AKMIDIListener, Playable, Timeline, TimelineObservable
where Composition: MIDIComposition {
    
    private let midi: AKMIDI
    private let mixer: AKMixer
    private let pumper: AKCompressor
    private let metronome: MDMetronome
    private let metronomeSettings: MDMetronomeSettings
    fileprivate let sampler: MDMIDISampler
    fileprivate let sequence: AKSequencer
    fileprivate var composition: Composition?
    
    private let timeObserver = TimelineObserver()
    private let defaultTempo = MDDefaultMetronomeSettings.bpm
    private var pauseTime: TimeInterval = 0
    
    var isPlaying : Bool {
        var playing = self.sequence.isPlaying
        
        if let music = composition , playing == true {
            let currentPosition = self.sequence.currentPosition
            playing = AKDuration(beats: music.length) > currentPosition
        }
        
        return playing
    }
    
    var duration: TimeInterval {
        return self.sequence.seconds(duration: self.sequence.length)
    }
    
    var currentTime: TimeInterval {
        return self.sequence.seconds(duration: self.sequence.currentRelativePosition)
    }
    
    // MARK: - init adn deinit
    
    deinit {
        removeObserver()
        metronome.stop()
    }
    
    fileprivate init(musicbank: Soundbank,
                     metronomeTempo: Double,
                     metronomeSound: Soundbank.Audio,
                     metronomeSettings: MDMetronomeSettings,
                     onNoteEvent: BlockOnNoteEvent?) {
        AudioKit.stop()
        mixer = AKMixer()
        sampler = MDMIDISampler()
        pumper = AKCompressor(mixer)
        sequence = AKSequencer()
        midi = AKMIDI()
        
        metronome = MDMetronome(beats: metronomeTempo,
                                tempo: .standard4d4,
                                volume: metronomeSettings.volume,
                                audio: metronomeSound)
        AudioKit.output = pumper
        AudioKit.start()
        
        mixer.connect(metronome.sampler)
        mixer.connect(sampler)
        metronome.prepare()
        
        sequence.setTempo(defaultTempo)
        
        sampler.loadMelodicSoundFont(musicbank.audio.soundfont,
                                     preset: musicbank.audio.preset)
        sampler.enableMIDI(midi.client, name: String(describing: type(of: self)))
        
        self.metronomeSettings = metronomeSettings
        sampler.onNoteHandler = onNoteEvent
    }

    convenience init (composition: Composition,
                      musicbank: Soundbank,
                      metronomeSource: Soundbank.Audio,
                      metronomeSettings: MDMetronomeSettings,
                      onNoteEvent: BlockOnNoteEvent?) {
        self.init(musicbank: musicbank,
                  metronomeTempo: composition.tempo,
                  metronomeSound: metronomeSource,
                  metronomeSettings: metronomeSettings,
                  onNoteEvent: onNoteEvent)
        self.composition = composition
        addNewTrack(to: sequence, from: composition.noteEvents,
                    duration: composition.length, toOutput: sampler.midiIn)
    }
    
    // MARK: - Public functions

    func play() {
        enablePlaybackInSilentMode()
        if Int(pauseTime) != 0 {
            self.sequence.setTime(pauseTime)
        }
        sequence.play()
        if metronomeSettings.enabled {
            metronome.play()
        }
    }
    
    func play(noteNumber: MIDINoteNumber, velocity: MIDIVelocity = 127) {
        sampler.play(noteNumber: noteNumber, velocity: velocity, channel: 0)
    }
    
    func pause() {
        let time = self.currentTime
        stop()
        pauseTime = time
    }
    
    func stop() {
        pauseTime = 0
        removeObserver()
        sequence.stop()
        sequence.rewind()
        metronome.stop()
    }
    
    func observeTime(call: @escaping (TimeInterval, TimeInterval, Bool) -> Void) {
        timeObserver.observeTimeOf(object: self, frequency: 0.5, call: call)
    }
    
    func removeObserver() {
        timeObserver.removeObserving()
    }
    
    
    // MARK: - Private functions
    
    fileprivate func addNewTrack(to sequence: AKSequencer, from midiTrack: [Composition.TNoteEvent],
                                 duration: Double, toOutput output: MIDIEndpointRef) {
        guard midiTrack.count > 0 else { return }
        let musicTrack: AKMusicTrack = (sequence.newTrack())!
        musicTrack.setLength(AKDuration(beats: duration))
        
        midiTrack.sorted(by: {
            (note1, note2) -> Bool in
            return note1.time < note2.time
        }).playerNotes()
            .breakingAligements()
            .forEach {
                (note: MIDINoteEvent) in
                let number = Int(note.number)
                let velocity = MIDIVelocity(note.velocity)
                let position = AKDuration(beats: note.time)
                let duration = AKDuration(beats: note.duration)
                musicTrack.add(noteNumber: number,
                               velocity: velocity,
                               position: position,
                               duration: duration)
        }
        musicTrack.setMIDIOutput(output)
    }
    
}


//MARK: - Init with Music

extension MusicPlayer where Composition: Music {
    
    convenience init (music: Music,
                      musicbank: Soundbank,
                      metronomeSource: Soundbank.Audio,
                      metronomeSettings: MDMetronomeSettings,
                      onNoteEvent: BlockOnNoteEvent?) {
        self.init(musicbank: musicbank,
                  metronomeTempo: music.tempo,
                  metronomeSound: metronomeSource,
                  metronomeSettings: metronomeSettings,
                  onNoteEvent: onNoteEvent)
        composition = music as? Composition
        addTracksFrom(music: music, toOutput: sampler.midiIn)
    }
    
    private func addTracksFrom(music: Music, toOutput output:MIDIEndpointRef) {
        let tracks = music.tracks as? Set<Track>
        tracks?.enumerated().forEach({ (index: Int, track: Track) in
            guard let events = track.events?.allObjects as? [Music.TNoteEvent],
                events.count > 0 else { //escape empty tracks
                    return
            }
            addNewTrack(to: sequence, from: events, duration: music.length, toOutput: output)
        })
    }
    
}


//MARK: - MDMIDISampler

private class MDMIDISampler: AKMIDISampler {
    var onNoteHandler: BlockOnNoteEvent?
    override func play(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        super.play(noteNumber: noteNumber, velocity: velocity, channel: channel)
        print(noteNumber.description/+velocity.description/+channel.description)
        if let block = onNoteHandler {
            block(noteNumber)
        }
    }
    
    override open func stop(noteNumber: MIDINoteNumber, channel: MIDIChannel) {
        super.stop(noteNumber: noteNumber, channel: channel)
        print("stop: " + noteNumber.description/+channel.description)
    }
}


//MARK: - PlayerNoteEvent

fileprivate struct PlayerNoteEvent: MIDINoteEvent {
    var time: Double
    var duration: Double
    var number: Int16
    var velocity: Int16 = 127
    init(time: Double, duration: Double, number: Int16, velocity: Int16 = 127) {
        self.time = time
        self.number = number
        self.duration = duration
        self.velocity = velocity
    }
}


//MARK: - [MIDINoteEvent] to [PlayerNoteEvent]

fileprivate extension Array where Element: MIDINoteEvent {
    func playerNotes() -> [PlayerNoteEvent] {
        var playerNotes = [PlayerNoteEvent]()
        self.forEach { (note) in
            let short = PlayerNoteEvent(time: note.time./1,
                                        duration: note.duration./1,
                                        number: note.number)
            playerNotes.append(short)
        }
        return playerNotes
    }
    
    func breakingAligements() -> [PlayerNoteEvent] {
        var playerNotes = [PlayerNoteEvent]()
        for i in 0..<count {
            let note = self[i]
            if let other = findFirstLike(note: note, after: i),
                note.time.toInt(1) + note.duration.toInt(1) >= other.time.toInt(1) {
                let duration = other.time - note.time - 0.1
                print("GameNoteEvent(time: \(note.time), number: \(note.number), duration: \(note.duration))->\(duration),")
                playerNotes.append(PlayerNoteEvent(time: note.time,
                                                   duration: duration,
                                                   number: note.number))
            } else {
                print("GameNoteEvent(time: \(note.time), number: \(note.number), duration: \(note.duration)),")
                playerNotes.append(PlayerNoteEvent(time: note.time,
                                                   duration: note.duration,
                                                   number: note.number))
            }
        }
        return playerNotes
    }
    
    func findFirstLike(note: MIDINoteEvent, after index: Int) -> MIDINoteEvent? {
        for i in (index + 1)..<self.count {
            if let otherNote = self.objectAt(index: i),
                otherNote.number == note.number {
                return otherNote
            }
        }
        return nil
    }
}

