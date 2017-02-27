//
//  GameTrack.swift
//  Moodles
//
//  Created by VladislavEmets on 2/9/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

struct GameTrack: MIDIComposition {
    typealias TNoteEvent = GameNoteEvent
    var noteEvents:[GameNoteEvent]
    var tempo: Double
    var length: Double = 0
    let name: String
    
    init(name: String, tempo: Double, notes: [GameNoteEvent]) {
        self.name = name
        self.noteEvents = notes
        self.tempo = tempo
        notes.sorted { (first, second) -> Bool in
            return first.time < second.time
            }
            .last
            .map {
                self.length = $0.time + $0.duration
        }
    }
}


struct GameNoteEvent: MIDINoteEvent, Equatable {
    var time: Double
    var number: Int16
    var duration: Double
    var velocity: Int16 = 127
    
    init(time: Double, number: Int16, duration: Double) {
        self.time = time
        self.number = number
        self.duration = duration
    }
    
    public static func ==(lhs: GameNoteEvent, rhs: GameNoteEvent) -> Bool {
        return lhs.number == rhs.number
    }
}


//FIXME: we also can fetch track name from music json
extension GameTrack {
    static func fromMusicJSON(music: String) -> GameTrack? {
        guard
            let data = music.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)),
            let jsonData = try? JSONSerialization.jsonObject(with: data,
                                                             options: JSONSerialization.ReadingOptions()),
            let musicDictionary = jsonData as? [String: Any],
            let noteEvents = musicDictionary[MusicJSON.events] as? [Any]
            else {
            return nil
        }
        
        var events:[GameNoteEvent] = []
        noteEvents.forEach { (note) in
            if let noteInfo = note as? [AnyObject],
                noteInfo.count == MusicJSON.NotePropertiesCount {
                let time = noteInfo[MusicJSON.NoteInfoKeys.time] as! Double
                let duration = noteInfo[MusicJSON.NoteInfoKeys.duration] as! Double
                let number = noteInfo[MusicJSON.NoteInfoKeys.number] as! Int16
                let gameNote = GameNoteEvent(time: time, number: number, duration: duration)
                events.append(gameNote)
            }
        }
        events.sort { (event1, event2) -> Bool in
            return event1.time < event2.time
        }
        let track = GameTrack(name: "", tempo: MDDefaultMetronomeSettings.bpm, notes: events)
        return track
    }
}
