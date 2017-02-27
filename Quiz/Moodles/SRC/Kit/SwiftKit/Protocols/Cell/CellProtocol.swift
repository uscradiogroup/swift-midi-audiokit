//
//  CellProtocol.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

public protocol CellProtocol {
    
    associatedtype argType
    
    func fillFrom(model:argType)
    
}
