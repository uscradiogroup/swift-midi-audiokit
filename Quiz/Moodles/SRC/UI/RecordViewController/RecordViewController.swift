//
//  RecordViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 12/1/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit
import AudioKit
import Mixpanel


class RecordViewController:
PadViewController,
MDNavigationProtocol,
PerformanceRecorderDelegate {
    
    typealias RootViewType = PadView
    
    let kTrackDuration: TimeInterval = 60;
    var performanceRecorder: PerformanceRecorder?
    var lastTouchIndex: IndexPath? = nil
    var recordTimer: Timer?
    var isRecording = false

    
    // MARK: -  LifecicleViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if performanceRecorder == nil {
            performanceRecorder = PerformanceRecorder(musicbank: Config.pianoSoundBank,
                                                      metronomeSource: Config.metronome,
                                                      metronomeSettings: MDMetronomeUserSettings())
            performanceRecorder?.delegate = self
        }
    }
    
    // MARK: -  IBActions
    
    @IBAction func onStopRecording(_ sender: AnyObject) {
        recrod(false)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        let logPress = UILongPressGestureRecognizer(target: self, action :  #selector(handleTap(gestureReconizer:)))
        logPress.minimumPressDuration = 0
        cell.addGestureRecognizer(logPress)
        return cell
    }
    
    // MARK: -  Overriden methods
    
    // MARK: -  Public methods
    
    // MARK: -  Private methods
    
    fileprivate func showAlertForRecordResult(_ record: RecordedSequence) {
        if record.noteEvents.count == 0 { return }
        presentAlertWithBlackKeyboard(title: "Save As",
                                      message: "Please enter a song name.",
                                      placeholder: "Record name",
                                      cancel: "Cancel",
                                      confirm: "Ok",
                                      onConfirm: { [weak self] text in
                                        if let name = text {
                                            self?.saveRecordResult(record, name: name)
                                        }
        })
    }
    
    
    fileprivate func saveRecordResult(_ result: RecordedSequence, name: String) {
        var text = name.reducedTo(length: 100)
        if text.isEmpty {
            text = "Undefined - \(UUID().uuidString)"
        }
 
        createMusicContextFrom(sequence: result, name: text)
            .then { music -> Void in
                Mixpanel.mainInstance().track(event: MDMixpanel.Event.musicSaved)
                print("Success: \(music)")
            }.catch { error in
                print("Error: \(error)")
        }
        
    }
    
    fileprivate func recrod(_ record: Bool) {
        if isRecording != record {
            isRecording = record
            if record {
                rootView.startRecording()
                navigationController?.withSlider()?.hideSliderAndShortcut(animated: true)
                Mixpanel.mainInstance().track(event: MDMixpanel.Event.recordSong)
                performanceRecorder?.record(kTrackDuration)
                startRecordingTimer()
            } else {
                if let recordedSequence = performanceRecorder?.stop() {
                    showAlertForRecordResult(recordedSequence)
                }
                modifyViewEndRecording()
            }
        }
    }
    
    fileprivate func modifyViewEndRecording () {
        rootView.stopRecording()
        navigationController?.withSlider()?.makeShortcutVisible(true, animated: true)
        recordTimer?.invalidate()
    }
    
    fileprivate func startRecordingTimer () {
        recordTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            [weak self] (timer) in
            guard let recorder = self?.performanceRecorder else {
                return
            }
            let timeLeft: TimeInterval = recorder.timeLeft()
            self?.rootView.updateRecordedTime(timeLeft)
            if timeLeft <= 0 {
                self?.recrod(false)
            }
        })
    }
    

    //MARK: - Gestures
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleTap(gestureReconizer: UILongPressGestureRecognizer){
        let tapPoint = gestureReconizer.location(in: rootView.collectionView) as CGPoint
        
        func updateTouchIndexAndPlay(index: IndexPath, tap: CGPoint) {
            lastTouchIndex = index
            let note = notes[index.item]
            performanceRecorder?.play(noteNumber: note.value, velocity: 127)
            rootView.playAnimation(index: index.item, tapPoint: tap)
        }
        
        if let indexPath = rootView.collectionView.indexPathForItem(at: tapPoint) {
            switch gestureReconizer.state {
            case .began:
                updateTouchIndexAndPlay(index: indexPath, tap: tapPoint)
            case .changed:
                if lastTouchIndex != indexPath {
                    updateTouchIndexAndPlay(index: indexPath, tap: tapPoint)
                }
            default: break
            }
        }
    }
    
    
    // MARK: - PerformanceRecorderDelegate
    
    func didStartPreparing(recorder: PerformanceRecorder) {
        isRecording = false
        modifyViewEndRecording()
        rootView.showActivity(show: true)
    }
    
    func didEndPreparing(recorder: PerformanceRecorder) {
        rootView.showActivity(show: false)
    }
    
    
    // MARK: - Bottom slider
    
    func handleCenterItemPressed() -> Bool {
        recrod(true)
        return true
    }

    
}
