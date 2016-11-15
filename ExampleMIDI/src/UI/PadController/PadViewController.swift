//
//  ViewController.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/13/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import AudioKit
import MagicalRecord
import ReactiveCocoa


class PadViewController: UIViewController, ViewControllerRootView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var cellSzie: CGSize = CGSize()
    lazy var notes: [Note] = {
        return Note.LoadNotesFromPList()
    }()
    
    var rootView: PadView {
        return self.view as! PadView
    }
    
    var performanceRecorder = PerformanceRecorder()
    
    var isRecording = false
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellSzie = calcCellSize(rootView.collectionView.frame.size)
        self.performanceRecorder = self.createPerformanceRecorder()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performanceRecorder.prepareRecorder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cellSzie = calcCellSize(rootView.collectionView.frame.size)
        rootView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Interface actions
    
    @IBAction func onPlayPause(_ sender: UIButton) {
        recrodOrStop()
    }
    
    @IBAction func onPressedNote(_ sender: UIButton, event:UIEvent) {
        if !self.isRecording {
            self.recrodOrStop()
        }
        turnOnKey(noteFor(sender: sender))
    }
    
    @IBAction func onReleasedNote(_ sender: UIButton, event:UIEvent) {
        turnOffKey(noteFor(sender: sender))
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView,
                          numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(collectionView: UICollectionView,
                          cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PadCell  = collectionView.dequeueReusableCellWithReuseIdentifier("PadCell", forIndexPath: indexPath) as! PadCell
        cell.fillFrom(model: notes[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = cellSizeFor(collectionView, indexPath: indexPath)
        return size
    }
    
    // MARK: Private methods
    
    private func cellSizeFor(collectionView: UICollectionView, indexPath: NSIndexPath) -> CGSize {
        return cellSzie
    }
    
    private func calcCellSize(viewSize: CGSize) -> CGSize {
        let x = Float(viewSize.width)
        let y = Float(viewSize.height)
        let n = Float(self.notes.count)
        let px = ceil(sqrt(n*x/y))
        var sx: Float = 0
        var sy: Float = 0
        
        if floor(px*y/x)*px < n {
            sx = y/ceil(px*y/x)
        } else {
            sx = x/px
        }
        
        let py = ceil(sqrt(n*y/x))
        
        if (floor(py*x/y)*py<n) {
            sy=x/ceil(x*py/y)
        } else {
            sy=y/py
        }
        
        let size: CGSize = CGSize(width: CGFloat(sx), height: CGFloat(sy))
        
        return size
    }
    
    private func createPerformanceRecorder() -> PerformanceRecorder {
        let performanceRecorder = PerformanceRecorder()
        performanceRecorder.masterVolume.volume = 2.0
        performanceRecorder.prepareRecorder()
        return performanceRecorder
    }
 
    private func noteFor(sender sender:UIButton) -> Note {
        let collectionView = self.rootView.collectionView
        let loc = collectionView.convertPoint(CGPointMake(sender.frame.midX, sender.frame.midY),
                                              fromView: sender.superview)
        let indexPath: NSIndexPath? = collectionView.indexPathForItemAtPoint(loc)
        let note = notes[(indexPath?.item)!]
        return note
    }
    
    private func turnOffKey(key: Note) {
        performanceRecorder.stop(noteNumber: key.value)
    }
    
    private func turnOnKey(key: Note) {
        performanceRecorder.play(noteNumber: key.value, velocity: 127)
    }
    
    private func showAlertForRecordResult(record: RecordedSequence) {
        if record.noteEvents.count > 0 {
            let alertController = UIAlertController(title: "Should save", message: "Should save your prefomance ?", preferredStyle:.Alert)
            let okButton = UIAlertAction(title: "OK", style: .Default, handler: { action in
                var text = (alertController.textFields?.first?.text)!
                text = text.characters.count > 0 ? text : "Undefined - \(NSUUID().UUIDString)"
                let maxLength = 100
                if text.characters.count > maxLength {
                    let range = text.startIndex..<text.startIndex.advancedBy(maxLength)
                    text = text[range]
                }
                self.saveRecordResult(record, name: text)
            })
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
            
            alertController.addAction(okButton)
            alertController.addAction(cancelButton)
            alertController.preferredAction = okButton
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Record name"
            }
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func saveRecordResult(result: RecordedSequence, name: String) {
        createMusicContextFrom(sequence: result, name: name).observeOn(UIScheduler()).startWithResult { (result) in
            switch result {
            case let .Success(value):
                print("Success: \(value)")
            case let .Failure(error):
                print("Failure: \(error)")
            }
        }
    }
    
    private func recrodOrStop() {
        isRecording = !isRecording
        self.rootView.record(isRecording)
        if isRecording {
            self.performanceRecorder.record()
        } else {
            if let recordedSequence = performanceRecorder.stop() {
                self.showAlertForRecordResult(recordedSequence)
            }
            self.performanceRecorder.cleanupAll()
            self.performanceRecorder.prepareRecorder()
        }
    }
}

