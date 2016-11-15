//
//  TimeFunctions.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

public func formattedTimeFor(seconds seconds: Double) -> String {
    let hours = floor(seconds / 3600)
    let mins = floor(seconds / 60 % 60)
    let secs = floor(seconds % 60)
    
    return "\(Int(hours))h:\(Int(mins))m:\(Int(secs))s"
}
