//
//  MDMetronomeViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 11/17/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class MDMetronomeViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
ViewControllerRootView {
    
    typealias RootViewType = MDMetronomeView
    private let settings = MDMetronomeUserSettings()
    private let cellHeights = [60.0, 60.0, 80.0, 80.0, 100.0]

    private lazy var cells = {
        return [NotesTableViewCell.self,
                MetronomeTableViewCell.self,
                VolumeTableViewCell.self,
                BeatsTableViewCell.self,
                TempoTableViewCell.self]
        }()
    
    private lazy var metronome: MDSingleMetronome = {
        [unowned self] in
        return MDSingleMetronome(settings: self.settings, metronomeSource: Config.metronome)
    }()
    
    private lazy var sample: MDSamplePlayer = {
        [unowned self] in
        return MDSamplePlayer(player: self.metronome)
    }()
    
    // MARK: -  Initializations and Deallocations
    
    // MARK: -  LifecicleViewController
    
    // MARK: -  Accessors
    
    // MARK: -  IBActions
    
    @IBAction func onBackToRecord(_ sender: Any) {
        backToRecord()
    }
    
    @IBAction func onStartDrag(_ sender: UISlider) {
        sample.play(duration: 3)
    }
    
    @IBAction func onEndDrag(_ sender: UISlider) {
        sample.play(duration: 3)
    }
    
    @IBAction func onChangeVolume(_ sender: UISlider) {
        settings.volume = Double(sender.value)
        metronome.changeVolume(settings.volume)
        sample.play(duration: 3)
    }
    
    @IBAction func onChangeBeats(_ sender: UISlider) {
        settings.bpm = Double(sender.value)
        metronome.changeBeats(settings.bpm)
        sample.play(duration: 3)
    }
    
    @IBAction func onSwitchNotes(_ sender: UISwitch) {
        settings.showNotes = sender.isOn
    }
    
    @IBAction func onSwitchMetro(_ sender: UISwitch) {
        settings.enabled = sender.isOn
    }
    
    @IBAction func onStandard(_ sender: AnyObject) {
       
    }
    
    @IBAction func onWaltz(_ sender: AnyObject) {
  
    }
    
    @IBAction func onBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -  TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: cells[indexPath.row]),
                                                 for: indexPath) as! SettingsTableViewCell
        cell.fillFrom(model: settings)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeights[indexPath.row])
    }
    
    // MARK: -  Public methods
    
    // MARK: -  Private methods
    
}


