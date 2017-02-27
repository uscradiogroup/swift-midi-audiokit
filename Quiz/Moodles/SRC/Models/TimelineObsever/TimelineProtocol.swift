//
//  TimelineProtocol.swift
//  Moodles
//
//  Created by VladislavEmets on 12/30/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

typealias TimeProgressOberver = (TimeInterval, TimeInterval, Bool)->Void

protocol Timeline: class {
    var duration: TimeInterval {get}
    var currentTime: TimeInterval {get}
}

protocol TimelineObservable {
    func observeTime(call: @escaping TimeProgressOberver)
    func removeObserver()
}
