//
//  MIDIComposition.swift
//  Moodles
//
//  Created by VladislavEmets on 2/10/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

protocol MIDIComposition {
    associatedtype TNoteEvent: MIDINoteEvent
    var noteEvents:[TNoteEvent] { get }
    var length: Double { get }
    var tempo: Double { get }
}


protocol MIDINoteEvent {
    var time: Double { get }
    var duration: Double { get }
    var number: Int16 { get }
    var velocity: Int16 { get }
}




