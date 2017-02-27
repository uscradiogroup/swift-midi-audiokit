//
//  AKSequencer+WriteFileToMIDI.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import AudioKit

extension AKSequencer {
    
    func save(toUrlPath: NSURL) -> OSStatus {
        var status: OSStatus = 0
        status = MusicSequenceFileCreate(self.sequence!, toUrlPath, .midiType, .eraseFile, 0)
        return status
    }
    
    
    func addMetadata(metronomBeats: Int) {
        guard let track = getTempoTrack() else {
            return
        }
        let data = [UInt8](String(metronomBeats).utf8)
        var metaEvent = MIDIMetaEvent()
        metaEvent.metaEventType = 0x01 // Text
        metaEvent.dataLength = UInt32(data.count)
        withUnsafeMutablePointer(to: &metaEvent.data, {
            ptr in
            for i in 0 ..< data.count {
                ptr[i] = data[i]
            }
        })
        let status = MusicTrackNewMetaEvent(track, MusicTimeStamp(0), &metaEvent)
    }
    
    
    private func getMetronomeMeta() -> Double {
        guard let track = getTempoTrack() else {
            return 0
        }
        
        var beats: Double = 0
        var iterator: MusicEventIterator?
        let resIterator = NewMusicEventIterator(track, &iterator)
        if resIterator != noErr {
            print(self.errnoDescription())
            return 0
        }
        
        var hasCurrentEvent:DarwinBoolean = true
        var result = MusicEventIteratorHasCurrentEvent(iterator!, &hasCurrentEvent)
        if result != noErr {
            print(self.errnoDescription())
            return 0
        }
        
        var eventTimeStamp = MusicTimeStamp(0)
        var eventType = MusicEventType()
        var eventData: UnsafeRawPointer? = nil
        var eventDataSize: UInt32 = 0
        
        var fetchStatus: OSStatus = noErr
        while (hasCurrentEvent.boolValue == true) {
            fetchStatus = MusicEventIteratorGetEventInfo(iterator!,
                                                         &eventTimeStamp,
                                                         &eventType,
                                                         &eventData,
                                                         &eventDataSize)
            if fetchStatus != OSStatus(noErr) {
                print(self.errnoDescription())
                break
            }
            
            switch eventType {
            case kMusicEventType_Meta:
                var nameMeta: MIDIMetaEvent = (eventData?.load(as: MIDIMetaEvent.self))!
                var dataArr = [UInt8]()
                withUnsafeMutablePointer(to: &nameMeta.data, { ptr in
                    for i in 0 ..< Int(nameMeta.dataLength) {
                        dataArr.append(ptr[i])
                    }
                    print(dataArr)
                })
                let resultString = NSString(bytes: dataArr, length:
                    dataArr.count, encoding: String.Encoding.utf8.rawValue) as! String
                beats = Double(resultString)!
            default:
                print("UNDEFINED")
            }
            
            fetchStatus = MusicEventIteratorHasNextEvent(iterator!, &hasCurrentEvent)
            if fetchStatus != OSStatus(noErr) {
                print(self.errnoDescription())
                break
            }
            
            fetchStatus = MusicEventIteratorNextEvent(iterator!)
            if fetchStatus != OSStatus(noErr) {
                print(self.errnoDescription())
                break
            }
        }

        return beats
    }
    
    
    func getTempoTrack() -> MusicTrack? {
        let aSequence: MusicSequence = self.sequence!
        var result: OSStatus = noErr
        
        let pointerTrack = UnsafeMutablePointer<MusicTrack?>.allocate(capacity: 1)
        result = MusicSequenceGetTempoTrack(aSequence, pointerTrack)
        if (noErr != result) {
            return nil
        }
        let track:MusicTrack? = pointerTrack.pointee
        return track
    }

    private func errnoDescription() -> String {
        return String.init(cString: strerror(errno))
    }
    
}

