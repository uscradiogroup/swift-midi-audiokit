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
    
    func save(toUrlPath toUrlPath: NSURL) -> OSStatus {
        var status: OSStatus = 0
        status = MusicSequenceFileCreate(self.sequence, toUrlPath, .MIDIType, .EraseFile, 0)
        return status
    }
    
}
