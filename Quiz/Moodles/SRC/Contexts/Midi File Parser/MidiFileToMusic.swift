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
import PromiseKit


func parse(fileUrl: URL) -> Promise<Music> {
    return Promise(resolvers: {fullfill, reject in
        let sequence = AKSequencer(urlPath: fileUrl as NSURL)
        let url = fileUrl
        var musci: Music?
        
        MagicalRecord.save({ (context) in
            musci = Music.mr_createEntity(in: context)
            musci?.date = Date()
            musci?.name = url.lastPathComponent.replacingOccurrences(of: "." + url.pathExtension, with: "")
            
            var length: Double = 0
            sequence.tracks.forEach { track in
                let trackModel: Track = Track.mr_createEntity(in: context)!
                musci?.addToTracks(trackModel)
                let trackLength = Double(track.length)
                trackModel.length = trackLength
                
                if trackLength > length {
                    length = trackLength
                }
                
                var iterator: MusicEventIterator? = nil
                NewMusicEventIterator(track.internalMusicTrack!, &iterator)
                var eventTime = MusicTimeStamp(0)
                var eventType = MusicEventType()
                var eventData: UnsafeRawPointer? = nil
                var eventDataSize: UInt32 = 0
                var hasNextEvent: DarwinBoolean = false
                MusicEventIteratorHasCurrentEvent(iterator!, &hasNextEvent)
                while(hasNextEvent).boolValue {
                    MusicEventIteratorGetEventInfo(iterator!, &eventTime, &eventType, &eventData, &eventDataSize)
                    
                    if kMusicEventType_MIDINoteMessage == eventType {
                        let noteMessage: MIDINoteMessage = (eventData?.bindMemory(to: MIDINoteMessage.self, capacity: 1).pointee)!
                        let noteEvent = NoteEvent.mr_createEntity(in: context)!
                        noteEvent.type = "note"
                        noteEvent.number = Int16(noteMessage.note)
                        noteEvent.velocity = Int16(noteMessage.velocity)
                        noteEvent.duration = Double(noteMessage.duration)
                        noteEvent.time = eventTime
                        trackModel.addToEvents(noteEvent)
                    }
                    
                    if kMusicEventType_Meta == eventType {
                        var meta: MIDIMetaEvent = (eventData?.load(as: MIDIMetaEvent.self))!
                        if meta.metaEventType == 0x01 {
                            var dataArr = [UInt8]()
                            withUnsafeMutablePointer(to: &meta.data, { ptr in
                                for i in 0 ..< Int(meta.dataLength) {
                                    dataArr.append(ptr[i])
                                }
                            })
                            let oldString = NSString(bytes: dataArr, length: dataArr.count,
                                     encoding: String.Encoding.utf8.rawValue)
                            if let string = oldString as? String,
                                let beats = Double(string) {
                                musci?.tempo = beats
                            }
                        }
                    }
                    
                    MusicEventIteratorNextEvent(iterator!)
                    MusicEventIteratorHasCurrentEvent(iterator!, &hasNextEvent)
                }
            }
            
            musci?.length = length
        },
                           completion: { (saved, error) in
                            
                            if let error = error {
                                reject(error)
                            } else {
                                musci = musci?.mr_(in: NSManagedObjectContext.mr_default())
                                fullfill(musci!)
                            }
        })
    })
}
    
