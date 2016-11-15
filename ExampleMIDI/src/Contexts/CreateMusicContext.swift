//
//  CreateMusicContext.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/20/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import MagicalRecord

func createMusicContextFrom(sequence sequence: RecordedSequence, name: String) -> SignalProducer<Music?, NSError> {
    return SignalProducer({ (observer, compositeDisposable) in
        var result: Music?
        MagicalRecord.saveWithBlock({ context in
            let music: Music = Music.MR_createEntityInContext(context)!
            music.date = NSDate()
            music.name = name
            music.length = sequence.sequenceLength
            let track = Track.MR_createEntityInContext(context)!
            track.length = sequence.sequenceLength
            music.addToTracks(track)
            sequence.noteEvents.forEach({ noteEvent in
                let note = NoteEvent.MR_createEntityInContext(context)!
                track.addToEvents(note)
                note.time = noteEvent.time
                note.number = Int16(noteEvent.number)
                note.velocity = Int16(noteEvent.velocity)
                note.duration = noteEvent.duration
                note.type = noteEvent.type
            })
            result = music
        }) { (didSave, error) in
            if let error = error {
                observer.sendFailed(error)
            } else {
                result = result?.MR_inContext(NSManagedObjectContext.MR_defaultContext())
                observer.sendNext(result)
                observer.sendCompleted()
            }
        }
    })
}
