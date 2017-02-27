//
//  SettingsCells.swift
//  Moodles
//
//  Created by VladislavEmets on 2/13/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

class SettingsTableViewCell: UITableViewCell, CellProtocol {
    typealias argType = MDMetronomeUserSettings
    func fillFrom(model: MDMetronomeUserSettings) {}
}


class NotesTableViewCell: SettingsTableViewCell {
    @IBOutlet weak var switchNotes: UISwitch!
    override func fillFrom(model: MDMetronomeUserSettings) {
        switchNotes.isOn = model.showNotes
    }
}


class MetronomeTableViewCell: SettingsTableViewCell {
    @IBOutlet weak var switchMetronome: UISwitch!
    override func fillFrom(model: MDMetronomeUserSettings) {
        switchMetronome.isOn = model.enabled
    }
}


class VolumeTableViewCell: SettingsTableViewCell {
    @IBOutlet weak var sliderVolume: UISlider!
    override func fillFrom(model: MDMetronomeUserSettings) {
        sliderVolume.value = Float(model.volume)
    }
}


class BeatsTableViewCell: SettingsTableViewCell {
    @IBOutlet weak var sliderBeats: UISlider!
    @IBOutlet weak var labelBeats: UILabel!
    
    @IBAction func onChangeValue(_ sender: UISlider) {
        labelBeats.text = String("Beats per Minute: \(Int(sender.value))")
    }
    
    override func fillFrom(model: MDMetronomeUserSettings) {
        labelBeats.text = String("Beats per Minute: \(Int(model.bpm))")
        sliderBeats.value = Float(model.bpm)
    }
}


class TempoTableViewCell: SettingsTableViewCell {
    override func fillFrom(model: MDMetronomeUserSettings) {
        
    }
}
