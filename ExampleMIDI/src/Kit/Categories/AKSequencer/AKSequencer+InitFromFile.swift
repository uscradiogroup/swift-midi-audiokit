//
//  AKSequencer+InitFromFile.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import AudioKit

extension AKSequencer {
    
    convenience init(urlPath: NSURL) {
        self.init()
        let fileURL = urlPath
        
        MusicSequenceFileLoad(sequence, fileURL, .MIDIType, .SMF_PreserveTracks)
        
        tracks.removeAll()
        var count: UInt32 = 0
        MusicSequenceGetTrackCount(sequence, &count)
        
        for i in 0 ..< count {
            var musicTrack: MusicTrack = nil
            MusicSequenceGetIndTrack(sequence, UInt32(i), &musicTrack)
            tracks.append(AKMusicTrack(musicTrack: musicTrack, name: "InitializedTrack"))
        }
    }
    
    convenience init(filePath:String) {
        self.init(urlPath: NSURL.fileURLWithPath(filePath))
    }
}
