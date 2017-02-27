//
//  UITableView+Extension.swift
//  Moodles
//
//  Created by VladislavEmets on 1/27/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

extension UITableView {
    func indexPathForCellContains(view sender: UIView) -> IndexPath? {
        let loc = convert(CGPoint(x: sender.frame.midX, y: sender.frame.midY),
                                     from: sender.superview)
        let indexPath = indexPathForRow(at: loc)
        return indexPath
    }
}
