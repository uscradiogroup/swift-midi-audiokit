//
//  GameTour.swift
//  Moodles
//
//  Created by VladislavEmets on 2/9/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation


protocol GameTour: class, Equatable {
    var finished:Bool { get }
    func restart()
}


class MDSimonGame: GameTour {
    
    static func ==(lhs: MDSimonGame, rhs: MDSimonGame) -> Bool {
        return lhs === rhs
    }
    
    internal var track: GameTrack
    internal var finished: Bool {
        return isFinished
    }
    
    private var playedNotes: [GameNoteEvent] = []
    private var isFinished:Bool = false
    
    internal required init(track: GameTrack) {
        self.track = track
    }
    
    internal func append(note: GameNoteEvent) -> (noteValid: Bool, tourFinished: Bool) {
        playedNotes.append(note)
        let valid = playedNotes.orderedSubsequenceOf(track.noteEvents)
        isFinished = valid && playedNotes.count == track.noteEvents.count
        return (valid, isFinished)
    }

    internal func restart() {
        isFinished = false
        playedNotes.removeAll()
    }
    
}
