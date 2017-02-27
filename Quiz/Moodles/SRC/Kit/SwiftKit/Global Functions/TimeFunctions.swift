//
//  TimeFunctions.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

public func formattedTimeFor(seconds: Double) -> String {
    let hours = Int(floor(seconds / 3600))
    let mins = Int(floor((seconds / 60).truncatingRemainder(dividingBy: 60)))
    let secs = Int(floor(seconds.truncatingRemainder(dividingBy: 60)))
    let string = "\(Int(hours))h:\(Int(mins))m:\(Int(secs))s"
    return string
}
