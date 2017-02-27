//
//  Array+Extension.swift
//  Moodles
//
//  Created by VladislavEmets on 2/10/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

extension Array {
    func objectAt(index: Int) -> Element? {
        guard index < self.count else {
            return nil
        }
        return self[index]
    }
}


extension Array where Element: Equatable {
    func orderedSubsequenceOf(_ supersequense: Array) -> Bool {
        var ordered = false
        if self.count <= supersequense.count {
            ordered = true
            var iterator = zip(self, supersequense).makeIterator()
            while let (left, right) = iterator.next() {
                if left != right {
                    ordered = false
                    break
                }
            }
        }
        return ordered
    }
}


struct PairIterator<T>: IteratorProtocol {
    typealias Element = (T,T)
    
    private let array:[T]
    private var position = -1
    
    init(_ array:[T]) {
        self.array = array
    }
    
    mutating func next() -> (T, T)? {
        position = position + 1
        if let first = array.objectAt(index: position),
            let second = array.objectAt(index: position + 1) {
            return (first, second)
        }
        return nil
    }
}
