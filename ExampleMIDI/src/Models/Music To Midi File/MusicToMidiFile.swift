//
//  MusicToMidiFile.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import AudioKit

// Save Music at DocumentDirectory in folder /MIDIs
func saveMusicToMidFile(music music:Music) -> (saved: Bool, path: String?) {
    var isSaved = false
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    let fileManager = NSFileManager.defaultManager()
    
    let folderPath = documentsPath.stringByAppendingString("/MIDIs")
    if !fileManager.fileExistsAtPath(folderPath) {
        do {
            try fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return (saved: false, path: nil)
        }
    }
    
    let midiName = music.name ?? "Undefined"
    let midiPath = folderPath.stringByAppendingString("/\(midiName).mid")
    let midiUrl = NSURL(fileURLWithPath: midiPath)
    let sequence = sequencerFor(music)
    let status: OSStatus = sequence.save(toUrlPath: midiUrl)
    
    isSaved = status == 0
    
    return (saved: isSaved, path: midiPath)
}

private func sequencerFor(music: Music) -> AKSequencer {
    let sequence = AKSequencer()

    let tracks = music.tracks as? Set<Track>
    
    tracks?.enumerate().forEach({ (index: Int, track: Track) in
        let musicTrack = sequence.newTrack()!
        musicTrack.setLength(AKDuration(beats: track.length))
        
        let events = track.events as? Set<NoteEvent>
        
        events?.forEach { (note: NoteEvent) in
            musicTrack.add(noteNumber: Int(note.number),
                velocity: MIDIVelocity(note.velocity),
                position: AKDuration(beats: note.time),
                duration: AKDuration(beats: note.duration))
        }
    })
    
    return sequence
}
