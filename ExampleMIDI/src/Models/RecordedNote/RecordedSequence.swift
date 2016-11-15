//
//  RecordedSequence.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/15/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

struct RecordedSequence {
    let sequenceLength: Double // in beats
    let noteEvents: Array<RecordedNoteEvent>
}
