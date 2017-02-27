//
//  MDMetronomeUserSettings.swift
//  Moodles
//
//  Created by VladislavEmets on 11/22/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation


class MDMetronomeUserSettings: MDMetronomeSettings {
    
    private var userDefaults    = UserDefaults.standard
    
    private struct SettingsKey {
        static let metroBPM     = "keyMetroBPM"
        static let metroVolume  = "keyMetroVolume"
        static let metroEnabled = "keyMetroEnabled"
        static let showNotes    = "keyShowNotes"
    }
    
    internal var tempo: MDMetronomeTempo = .standard4d4
    
    internal var volume: Double {
        didSet {
            validateVolumeValue()
        }
    }
    
    internal var bpm: Double {
        didSet {
            validateBpmValue()
        }
    }
    
    internal var enabled: Bool {
        didSet {
            userDefaults.set(enabled, forKey: SettingsKey.metroEnabled)
            userDefaults.synchronize()
        }
    }
    
    internal var showNotes: Bool {
        didSet {
            userDefaults.set(showNotes, forKey: SettingsKey.showNotes)
            userDefaults.synchronize()
        }
    }

    // MARK: - Initialization
    
    init() {
        showNotes = userDefaults.bool(forKey: SettingsKey.showNotes)
        bpm = userDefaults.double(forKey: SettingsKey.metroBPM)
        enabled = userDefaults.bool(forKey: SettingsKey.metroEnabled)
        volume = userDefaults.double(forKey: SettingsKey.metroVolume)
        validateBpmValue()
        validateVolumeValue()
    }
    
    
    // MARK: - Private
    
    private func validateBpmValue () {
        let synced = userDefaults.synchronize(value: bpm,
                                       forKey: SettingsKey.metroBPM,
                                       minValue: MDDefaultMetronomeSettings.bpm,
                                       withDefault: MDDefaultMetronomeSettings.bpm)
        if bpm != synced {
            bpm = synced
        }
    }
    
    private func validateVolumeValue () {
        let synced = userDefaults.synchronize(value: volume,
                                          forKey: SettingsKey.metroVolume,
                                          minValue: MDDefaultMetronomeSettings.minVolume,
                                          withDefault: MDDefaultMetronomeSettings.volume)
        if volume != synced {
            volume = synced
        }
    }
    
}

