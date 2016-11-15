//
//  Note.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/14/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

struct Note: Hashable {
    let name: String
    let value: Int
    
    var hashValue: Int {
        get {
            let hashString = self.name + ";" + "\(self.value)"
            return hashString.hashValue
        }
    }
}

func ==(lhs: Note, rhs: Note) -> Bool {
    return lhs.name == rhs.name && lhs.value == rhs.value
}

