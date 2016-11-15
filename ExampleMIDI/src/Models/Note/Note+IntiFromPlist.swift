//
//  Note+IntiFromPlist.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/14/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

extension Note {
    
    static func LoadNotesFromPList() -> [Note] {
        var notes: [Note] = []
        if let path = NSBundle.mainBundle().pathForResource("NotesPlist", ofType: "plist") {
            let noteItems: Array<NSDictionary> = NSArray.init(contentsOfFile: path) as! Array<NSDictionary>
            noteItems.forEach({ item in
                let note: Note = Note(name: item["name"] as! String, value: item["value"] as! Int)
                notes.append(note)
            })
        }
        
        return notes
    }
    
}
