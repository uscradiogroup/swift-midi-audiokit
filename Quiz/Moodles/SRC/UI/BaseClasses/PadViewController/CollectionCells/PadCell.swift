//
//  PadCell.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/13/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit

class PadCell: UICollectionViewCell, CellProtocol  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewCircle: UIImageView!
    
    // MARK: - public
    
    func fillFrom(model: Note) {
        titleLabel.text = String(model.name)
    }
    
    func showNote(_ show: Bool) {
        titleLabel.alpha = show ? 1.0 : 0.0
        imageViewCircle.alpha = show ? 1.0 : 0.0
    }
}
