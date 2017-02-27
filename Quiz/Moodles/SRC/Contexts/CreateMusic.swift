//
//  CreateMusicContext.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/20/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import PromiseKit
import MagicalRecord

func createMusicContextFrom(sequence: RecordedSequence, name: String) -> Promise<Music> {
    return Promise(resolvers: {fullfill, reject in
        var result: Music?
        
        MagicalRecord.save({ context in
            let music: Music = Music.mr_createEntity(in: context)!
            music.date = Date()
            music.name = name
            music.tempo = sequence.metronomeTempo
            music.length = sequence.sequenceLength
            let track = Track.mr_createEntity(in: context)!
            track.length = sequence.sequenceLength
            music.addToTracks(track)
            sequence.noteEvents.forEach({ noteEvent in
                let note = NoteEvent.mr_createEntity(in: context)!
                track.addToEvents(note)
                note.time = noteEvent.time
                note.number = Int16(noteEvent.number)
                note.velocity = Int16(noteEvent.velocity)
                note.duration = noteEvent.duration
                note.type = noteEvent.type
                print(note)
            })
            result = music
        },
                           completion: { (didSave, error) in
                            if let error = error {
                                reject(error)
                            } else {
                                result = result?.mr_(in: NSManagedObjectContext.mr_default())
                                fullfill(result!)
                            }
        })
        
    })
}
