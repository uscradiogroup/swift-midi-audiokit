//
//  PlaybackViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 12/1/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit
import AudioKit


class PlaybackViewController: PadViewController {
    
    typealias RootViewType = PadView
    
    var music: Music?
    
    private var musicPlayer: MusicPlayer<Music>?
    private var playerNotesHandler: BlockOnNoteEvent {
        return { [weak self](note: MIDINoteNumber) in
            let path = IndexPath(item: note - 60, section: 0)   //FIXME: -60? What?
            guard let cell = self?.rootView.collectionView.cellForItem(at: path) else {
                print("Out of range with note \(note)")
                return
            }
            DispatchQueue.main.async {
                self?.rootView.playAnimation(index: path.item, tapPoint: cell.center)
            }
        }
    }
    
    
    // MARK: -  Class methods
    
    // MARK: -  Initializations
    
    deinit {
        self.musicPlayer?.stop()
    }
    
    
    // MARK: -  LifecicleViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.withSlider()?.makeShortcutVisible(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let track = music {
            self.musicPlayer = MusicPlayer<Music>(music: track,
                                                  musicbank: Config.pianoSoundBank,
                                                  metronomeSource: Config.metronome,
                                                  metronomeSettings: MDMetronomeUserSettings(),
                                                  onNoteEvent: playerNotesHandler)
        }
        self.musicPlayer?.play()
        self.observePlayerTime()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.withSlider()?.makeShortcutVisible(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.musicPlayer?.stop()
    }
    
    
    // MARK: -  IBActions
    
    @IBAction func onBack(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPausePlay(_ sender: AnyObject) {
        guard let player = musicPlayer else {
            return
        }
        if player.isPlaying {
            rootView.buttonStopRecord.isSelected = false
            player.pause()
        } else {
            rootView.buttonStopRecord.isSelected = true
            player.play()
            observePlayerTime()
        }
    }
    
    // MARK: -  Overriden methods
    
    
    // MARK: -  Public methods
    
    
    // MARK: -  Private methods
    
    private func observePlayerTime() {
        self.musicPlayer?.observeTime(call: { [weak self] (current, duration, isPlaying) in
            self?.rootView.updateRecordedTime(duration - current)
            if isPlaying == false {
                self?.rootView.updateRecordedTime(duration)
                self?.rootView.buttonStopRecord.isSelected = false
                self?.musicPlayer?.stop()
            }
        })
    }
    
}
