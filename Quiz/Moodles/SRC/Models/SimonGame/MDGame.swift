//
//  SimonGame.swift
//  Moodles
//
//  Created by VladislavEmets on 2/9/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation


protocol Quiz {
    associatedtype Tour:GameTour
    typealias GameFinished = Bool
    var currentTour: Tour { get }
    init?(tours: [Tour])
    func restart()
    func finishTour() -> GameFinished
}


class MDGame: Quiz {
    typealias Tour = MDSimonGame
    private let tours: [MDSimonGame]
    private var current: Int = 0
    internal var currentTour: MDSimonGame {
        return tours[current]
    }

    internal required init?(tours: [MDSimonGame]) {
        guard tours.count > 0 else {
            return nil
        }
        self.tours = tours
    }
    
    func finishTour() -> Quiz.GameFinished {
        if !currentTour.finished {return false}
        let next = (tours.index(of: currentTour))! + 1
        if next != tours.count {
            current = next
            return false
        } else {
            return true
        }
    }
    
    internal func restart() {
        tours.forEach { (tour) in
            tour.restart()
        }
        current = 0
    }
}
