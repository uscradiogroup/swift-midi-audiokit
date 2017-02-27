//
//  MusicToMidiFile.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import AudioKit


func saveMusicToMidFile(music:Music, usingName name:String? = nil) -> (saved: Bool, path: String?) {
    let (folderExist, savePath) = localFolder(.midis)
    guard let folderPath = savePath, folderExist == true else {
        return (saved: false, path: nil)
    }
    
    var isSaved = false
    let midiName = name ?? (music.name ?? "Undefined")
    let midiPath = folderPath + "/\(midiName)." + MDFileSystem.Extension.midi
    let midiUrl = URL(fileURLWithPath: midiPath)
    let sequence = sequencerFor(music)
    sequence.addMetadata(metronomBeats: Int(music.tempo))
    let status: OSStatus = sequence.save(toUrlPath: midiUrl as NSURL)
    isSaved = status == 0
    
    return (saved: isSaved, path: midiPath)
}


private func sequencerFor(_ music: Music) -> AKSequencer {
    let sequence = AKSequencer()
    let tracks = music.tracks as? Set<Track>
    
    tracks?.enumerated().forEach({ (index: Int, track: Track) in
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
