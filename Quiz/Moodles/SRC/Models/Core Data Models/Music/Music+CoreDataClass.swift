//
//  Music+CoreDataClass.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/15/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import CoreData

@objc(Music)
open class Music: NSManagedObject, MIDIComposition {

    typealias TNoteEvent = NoteEvent
    
    //FIXME: this behavior may be not obvious
    var noteEvents:[NoteEvent] {
        if let sequence = self.tracks?.allObjects.first as? [NoteEvent] {
            return sequence
        }
        return [NoteEvent]()
    }
    
    func shareId() -> String {
        return name! + String(describing: Int(self.date!.timeIntervalSinceReferenceDate))
    }
    
}
