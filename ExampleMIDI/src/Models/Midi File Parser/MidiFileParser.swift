//
//  MidiFileParser.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/19/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import AudioKit
import MagicalRecord
import ReactiveCocoa
import Result

class MidiFileParser {
    
    let url: NSURL
    let sequence: AKSequencer
    
    
    init(fileUrl: NSURL) {
        self.url = fileUrl
        self.sequence = AKSequencer(urlPath: fileUrl)
    }
    
    // MARK: - public functions
    
    func parse() -> SignalProducer<Music?, NSError> {
        let sequence = self.sequence
        let url = self.url
        return SignalProducer({ [sequence = sequence, url = url] (observer, compositeDisposable) in
            var musci: Music? = nil
            MagicalRecord.saveWithBlock({ (context) in
                musci = Music.MR_createEntityInContext(context)
                musci?.date = NSDate()
                let name = url.lastPathComponent?.stringByReplacingOccurrencesOfString("."+url.pathExtension!, withString: "")
                musci?.name = name!
                
                var length: Double = 0
                
                sequence.tracks.forEach { track in
                    let trackModel: Track = Track.MR_createEntityInContext(context)!
                    musci?.addToTracks(trackModel)
                    let trackLength = Double(track.length)
                    trackModel.length = trackLength
                    
                    if trackLength > length {
                        length = trackLength
                    }
                    
                    var iterator: MusicEventIterator = nil
                    NewMusicEventIterator(track.internalMusicTrack, &iterator)
                    var eventTime = MusicTimeStamp(0)
                    var eventType = MusicEventType()
                    var eventData: UnsafePointer<Void> = nil
                    var eventDataSize: UInt32 = 0
                    var hasNextEvent: DarwinBoolean = false
                    MusicEventIteratorHasCurrentEvent(iterator, &hasNextEvent)
                    while(hasNextEvent) {
                        MusicEventIteratorGetEventInfo(iterator, &eventTime, &eventType, &eventData, &eventDataSize)
                        if kMusicEventType_MIDINoteMessage == eventType {
                            let noteMessage: MIDINoteMessage = UnsafePointer<MIDINoteMessage>(eventData).memory
                            let noteEvent = NoteEvent.MR_createEntityInContext(context)!
                            noteEvent.type = "note"
                            noteEvent.number = Int16(noteMessage.note)
                            noteEvent.velocity = Int16(noteMessage.velocity)
                            noteEvent.duration = Double(noteMessage.duration)
                            noteEvent.time = eventTime
                            trackModel.addToEvents(noteEvent)
                        }
                        MusicEventIteratorNextEvent(iterator)
                        MusicEventIteratorHasCurrentEvent(iterator, &hasNextEvent)
                    }
                }
                
                musci?.length = length
            }) { (saved, error) in
                
                if let error = error {
                    observer.sendFailed(error)
                } else {
                    musci = musci?.MR_inContext(NSManagedObjectContext.MR_defaultContext())
                    observer.sendNext(musci)
                    observer.sendCompleted()
                }
            }
        })
    }
}
