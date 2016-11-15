//
//  Conductor.swift
//  AnalogSynthX
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import AudioKit

private typealias RecordingNote = (startTime: NSDate, velocity: MIDIVelocity)

class PerformanceRecorder: AKMIDIListener {
    
    let core = AKFMOscillatorBank()
    
    let masterVolume: AKMixer

    private(set) var isRecording: Bool = false
    
    private var recordingNotes: Dictionary<Int, RecordingNote> = Dictionary()
    private var recordedNotes: Array<RecordedNoteEvent> = Array()
    
    private var startRecordTime: NSDate? = nil;
    
    private let midi = AKMIDI()
    
    // MARK: - init adn deinit
    
    deinit {
        midi.clearListeners()
    }
    
    init() {
        AudioKit.stop()
        masterVolume = AKMixer(core)
        
        AudioKit.output = masterVolume

        midi.createVirtualPorts()
        midi.openInput("Session 1")
        midi.addListener(self)
    }
    
    // MARK: - AKMIDIListener protocol functions

    func receivedMIDINoteOn(noteNumber noteNumber: MIDINoteNumber,
                                       velocity: MIDIVelocity,
                                       channel: Int) {
        self.play(noteNumber: noteNumber, velocity: velocity)
    }
    func receivedMIDINoteOff(noteNumber noteNumber: MIDINoteNumber,
                                        velocity: MIDIVelocity,
                                        channel: Int) {
        self.stop(noteNumber: noteNumber)
    }
    
    // MARK - Public functions
    
    func cleanupAll() {
        cleanup()
        isRecording = false
        startRecordTime = nil
    }
    
    func prepareRecorder() {
        AudioKit.stop()
        AudioKit.output = masterVolume
        AudioKit.start()
    }
    
    func record() {
        if !isRecording {
            self.startRecordTime = NSDate()
            self.isRecording = true
            self.cleanup()
        }
    }
    
    func stop() -> RecordedSequence? {
        if isRecording {
            isRecording = false
            let sequenceLength: Double = NSDate().timeIntervalSinceDate(self.startRecordTime!)
            let recordedSequence = RecordedSequence(sequenceLength: sequenceLength, noteEvents: self.recordedNotes)
            self.startRecordTime = nil
            self.cleanup()
            
            return recordedSequence
        }
        return nil
    }
    
    func play(noteNumber noteNumber: MIDINoteNumber, velocity: MIDIVelocity) {
        if isRecording {
            self.core.play(noteNumber: noteNumber, velocity: velocity)
            let startTime = NSDate()
            self.recordingNotes[noteNumber] = RecordingNote(startTime, velocity)
        }
        
    }
    
    func stop(noteNumber noteNumber: MIDINoteNumber) {
        if isRecording {
            self.core.stop(noteNumber: noteNumber)
            let (startTime, velocity) = self.recordingNotes.removeValueForKey(noteNumber)!
            let endTime = NSDate()
            let beats = startTime.timeIntervalSinceDate(self.startRecordTime!)
            let duration = endTime.timeIntervalSinceDate(startTime)
            let noteEvent =  RecordedNoteEvent(time: beats, number: noteNumber, velocity:velocity, duration:duration)
            self.recordedNotes.append(noteEvent)
        }
    }
    
    // MARK: - Private functions
    
    private func cleanup() {
        self.recordingNotes.removeAll(keepCapacity: false)
        self.recordedNotes.removeAll(keepCapacity: false)
    }
}
