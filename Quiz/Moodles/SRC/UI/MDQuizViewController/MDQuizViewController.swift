//
//  MDQuizViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 2/10/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation
import AudioKit


class MDQuizViewController: PadViewController {
    
    typealias RootViewType = MDQuizView
    
    var game: MDGame?
    
    fileprivate var player: MusicPlayer<GameTrack>?
    fileprivate var loading = ActivityView.activityView()
    fileprivate var lastTouchIndex: IndexPath? = nil
    private var notesToShow = [Note]()
    
    fileprivate var demonstration = true {
        didSet {
            rootView.showDemonstrationScreen(show: demonstration)
        }
    }
    
    fileprivate var playerNotesHandler: BlockOnNoteEvent {
        return {
            [weak self](note: MIDINoteNumber) in
            let path = IndexPath(item: note - 60, section: 0)   //FIXME: -60? What?
            guard let cell = self?.rootView.collectionView.cellForItem(at: path) else {
                return
            }
            DispatchQueue.main.async {
                self?.rootView.playAnimation(index: path.item, tapPoint: cell.center)
            }
        }
    }

    
    // MARK: -  LifecicleViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.showReadyScreen(show: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.stop()
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! PadCell
        let logPress = UILongPressGestureRecognizer(target: self, action :  #selector(handleTap(gestureReconizer:)))
        logPress.minimumPressDuration = 0
        cell.addGestureRecognizer(logPress)
        cell.showNote(notesToShow.contains(notes[indexPath.item]))
        return cell
    }
    
    // MARK: -  IBActions
    
    @IBAction func onTapReadyButton(_ sender: Any) {
        rootView.showReadyScreen(show: false)
        playCurrentTourTask()
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -  Overriden methods
    
    // MARK: -  Public methods
    
    // MARK: -  Private methods

    fileprivate func showOnlyNotes(_ notes:[Int]) {
        notesToShow.removeAll()
        notesToShow.append(contentsOf: self.notes.filter { (note) -> Bool in
            return notes.contains(note.value)
        })
        rootView.collectionView.reloadData()
    }
    
    fileprivate func showAllNotesOnPad() {
        notesToShow.append(contentsOf: notes)
        rootView.collectionView.reloadData()
    }
    
    // MARK: - Gestures
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleTap(gestureReconizer: UILongPressGestureRecognizer){
        let tapPoint = gestureReconizer.location(in: rootView.collectionView) as CGPoint
        
        func updateTouchIndexAndPlay(index: IndexPath, tap: CGPoint) {
            lastTouchIndex = index
            let note = notes[index.item]
            let userNote = GameNoteEvent(time: 0, number: Int16(note.value), duration: 0)
            handleUserNote(note: userNote)
            player?.play(noteNumber: note.value)
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
}


fileprivate extension MDQuizViewController {
    
    // MARK: -  Game
    
    func handleUserNote(note: GameNoteEvent) {
        guard let game = self.game else {
            return
        }
        let (noteValid, tourFinished) = game.currentTour.append(note: note)
        if tourFinished == true {
            let gameFinished = game.finishTour()
            if gameFinished {
                presentAlert(message: "",
                             title: "Game finished",
                             confirm: "Ok",
                             handler: {
                                [weak self] (action) in
                    self?.navigationController?.popViewController(animated: true) })
            } else {
                rootView.showReadyScreen(show: true)
                presentAlert(message: "Tour finished")
            }
        }
        if noteValid == false {
            game.currentTour.restart()
            rootView.showReadyScreen(show: true)
            presentAlert(message: "Tour failed")
        }
    }
    
    func playCurrentTourTask() {
        guard let composition = game?.currentTour.track else {
            return
        }
        demonstration = true
        showAllNotesOnPad()
        player = MusicPlayer(composition: composition,
                             musicbank: Config.pianoSoundBank,
                             metronomeSource: Config.metronome,
                             metronomeSettings: MDMetronomeUserSettings(),
                             onNoteEvent: playerNotesHandler)
        player?.observeTime(call: {
            [weak self] (current, duration, playing) in
            if playing == false {
                self?.demonstration = false
                self?.player?.removeObserver()
                self?.presentAlert(message: "Ready?\nSet!",
                                   title: "Now it's your turn",
                                   confirm: "Go!", handler: nil)
            }
        })
        player?.play()
    }
    
    func restart() {
        game?.restart()
    }
}


extension GameTrack {
    func noteNumbers() -> [Int] {
        return noteEvents.map {
            return Int($0.number)
        }
    }
}
