//
//  Note.swift
//  Moodles
//
//  Created by Tommy Trojan on 11/17/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit

//MARK: - Note's are made up of Pitch, Duration, Timbre
class Note:NSObject {
    var pitch:Int?
    var duration:Float?
    var timbre:Int?
    
    init(pitch:Int, duration:Float) {
        self.pitch = pitch
        self.duration = duration
    }
}

class Track: NSObject {
    
    var notes:[Note]?
    
    init(number:Int, duration:Float) {
        
        self.notes = [Note]()
        
        super.init()
        
        //FIXME: - Eventually add Duration
        addNote(number: number, duration: duration)
    }
    
    func addNote(number:Int, duration:Float){
        //Convert the MIDI number to a Note
        let newNote = Note(pitch: number, duration: duration)
        //Add the notes to the Array
        notes?.append(newNote)
    }
    
    func serialize() -> NSDictionary {
        //A musician performs
        let performance = NSMutableArray()
        for n in notes! {
            //Each note is stored in an array
            let note = NSMutableDictionary()
                note["number"] = n.pitch!
                note["duration"] = n.duration!

            performance.add(note)
        }
        //The performance notes are organized into a track
        let track = NSMutableDictionary()
            track["notes"] = performance
        
        return track
    }
}
