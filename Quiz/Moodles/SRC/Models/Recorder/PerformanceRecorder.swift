//
//  Conductor.swift
//  AnalogSynthX
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import AudioKit
import PromiseKit

private typealias RecordingNote = (globalStartTime: NSDate, velocity: MIDIVelocity)


protocol PerformanceRecorderDelegate: class {
    func didStartPreparing(recorder: PerformanceRecorder)
    func didEndPreparing(recorder: PerformanceRecorder)
}


class PerformanceRecorder {
    
    weak var delegate: PerformanceRecorderDelegate?

    private let currentSoundBank: Soundbank
    private let metronomeSettings: MDMetronomeSettings
    private let metronomeSource: Soundbank.Audio
    
    private var mixer: AKMixer?
    private var sampler: AKMIDISampler?
    private var metronome: MDMetronome?
    private var compressor: AKCompressor?

    private var isRecording: Bool = false
    private var recordingNotes: Dictionary<Int, RecordingNote> = Dictionary()
    private var noteCompletions: Dictionary<Int, MDNoteCompletion> = Dictionary()
    
    private var recordedNotes = Array<RecordedNoteEvent>()
    private var startRecordTime: NSDate?
    private var recordMaxLength: TimeInterval = 0
    private var soundfontInfo: MDSoundFontDescriptor?
    private var readyToPlay: Bool = true
    
    
    // MARK: - init and deinit
    
    deinit {
        metronome?.stop()
        NotificationCenter.default.removeObserver(self)
    }
    
    init(musicbank: Soundbank, metronomeSource: Soundbank.Audio, metronomeSettings: MDMetronomeSettings) {
        AudioKit.stop()
        self.currentSoundBank = musicbank
        self.metronomeSettings = metronomeSettings
        self.metronomeSource = metronomeSource
        prepareWith(musicBank: currentSoundBank,
                    metronomeConfig: metronomeSource,
                    metronomeSettings: metronomeSettings)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(routeChanged(notification:)),
                                               name: NSNotification.Name.AVAudioSessionRouteChange,
                                               object: nil)
    }
    
    private func prepareWith(musicBank soundbank: Soundbank,
                             metronomeConfig:Soundbank.Audio,
                             metronomeSettings: MDMetronomeSettings) {
        metronome = MDMetronome(settings: metronomeSettings, audio: metronomeConfig)
        mixer = AKMixer()
        sampler = AKMIDISampler()
        compressor = AKCompressor(mixer!)
        AudioKit.output = compressor //output = compressor(mixer(sampler, bass))
        AudioKit.start()

        sampler?.loadMelodicSoundFont(soundbank.audio.soundfont,
                                      preset: soundbank.audio.preset)
        mixer?.connect(metronome!.sampler)
        mixer?.connect(sampler!)
        metronome?.prepare()
        
        let urlpath = Bundle.main.path(forResource: soundbank.audio.soundfont,
                                       ofType: kSoundfontExtension)
        let url:URL = URL(fileURLWithPath: urlpath!)
        soundfontInfo = MDSoundFontDescriptor(soundfontUrl: url)
        enablePlaybackInSilentMode()
    }
    
    // MARK: - Public functions
    
    func record(_ duration: TimeInterval) {
        if isRecording == false {
            enablePlaybackInSilentMode()
            if metronomeSettings.enabled {
                metronome?.play()
            }
            self.recordMaxLength = duration
            self.startRecordTime = NSDate()
            self.isRecording = true
            cleanupRecordedNotes()
        }
    }
    
    func stop() -> RecordedSequence? {
        if isRecording {
            finishLiveNotes()
            metronome?.stop()
            isRecording = false
            let sequenceLength: Double = NSDate().timeIntervalSince(self.startRecordTime! as Date)
            let recordedSequence = RecordedSequence(sequenceLength: sequenceLength,
                                                    metronomeTempo: metronomeSettings.bpm,
                                                    noteEvents: self.recordedNotes)
            self.startRecordTime = nil
            cleanupRecordedNotes()
            return recordedSequence
        }
        return nil
    }
    
    func timeLeft() -> TimeInterval {
        if let start = startRecordTime {
            return recordMaxLength - (Date().timeIntervalSince(start as Date))
        }
        return 0;
    }
    
    
    func play(noteNumber: MIDINoteNumber, velocity: Int) {
        if (readyToPlay == false) {
            return
        }
        print(noteNumber)
        sampler?.play(noteNumber: noteNumber, velocity: velocity, channel: 0)
        if isRecording {
            stop(noteNumber: noteNumber)
            let startTime = NSDate()
            let noteDuration = soundfontInfo!.durationOf(note: noteNumber)
            self.recordingNotes[noteNumber] = RecordingNote(startTime,
                                                            velocity)
            self.noteCompletions[noteNumber] = MDNoteCompletion().start(completeAfter: noteDuration,
                                                                        onComplete: {
                                                                            [weak self]()->Void in
                                                                            self?.stop(noteNumber: noteNumber)
                })
        }
    }
    
    
    // MARK: - Private functions
    
    fileprivate func stop(noteNumber: MIDINoteNumber) {
        if isRecording,
            let (globalStartTime, velocity) = recordingNotes.removeValue(forKey: noteNumber) {
            noteCompletions.removeValue(forKey: noteNumber)?.invalidate()
            let endTime = NSDate()
            let startTimeInTrack = globalStartTime.timeIntervalSince(self.startRecordTime! as Date)
            let duration = endTime.timeIntervalSince(globalStartTime as Date)
            let noteEvent =  RecordedNoteEvent(time: startTimeInTrack,
                                               number: noteNumber,
                                               velocity:velocity,
                                               duration:duration)
            self.recordedNotes.append(noteEvent)
            print("End \(noteNumber) with duration: \(duration)")
        }
    }
    
    
    fileprivate func finishLiveNotes () {
        let liveNotes = self.recordingNotes.keys
        liveNotes.forEach({note in
            self.stop(noteNumber: note)
        })
    }
    
    fileprivate func cleanupAll() {
        cleanupRecordedNotes()
        isRecording = false
        startRecordTime = nil
    }
    
    fileprivate func cleanupRecordedNotes() {
        self.recordingNotes.removeAll(keepingCapacity: false)
        self.recordedNotes.removeAll(keepingCapacity: false)
    }
 
    // MARK: - Notifications
    
    @objc private func routeChanged(notification: Notification) {
        DispatchQueue.main.async {
            self.delegate?.didStartPreparing(recorder: self)
        }
        readyToPlay = false
        AudioKit.stop()
        finishLiveNotes()
        cleanupAll()
        prepareWith(musicBank: currentSoundBank,
                    metronomeConfig: metronomeSource,
                    metronomeSettings: metronomeSettings)
        readyToPlay = true
        DispatchQueue.main.async {
            self.delegate?.didEndPreparing(recorder: self)
        }
    }

}


// MARK: - MDNoteCompletion

class MDNoteCompletion {
    
    private var onComplete: (()->Void)? = nil
    private var timer: Timer? = nil
    
    func start (completeAfter:TimeInterval, onComplete:@escaping ()->Void) -> MDNoteCompletion {
        self.onComplete = onComplete
        timer = Timer.scheduledTimer(withTimeInterval: completeAfter, repeats: false, block: {
            [weak self] finished in
            self?.onNoteFinish(timer: finished)
        })
        return self
    }
    
    func invalidate() {
        timer?.invalidate()
        self.onComplete = nil
        self.timer = nil
    }
    
    private func onNoteFinish (timer: Timer?) {
        if let block = onComplete {
            block()
        }
        invalidate()
    }
    
}

