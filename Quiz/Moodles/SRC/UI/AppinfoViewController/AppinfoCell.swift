//
//  AppinfoCell.swift
//  Moodles
//
//  Created by VladislavEmets on 11/17/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit

class AppinfoCell: UITableViewCell, CellProtocol {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewSepatator: UIImageView!
    @IBOutlet weak var imageViewAccessory: UIImageView!
    
    func fillFrom(model: AppInfoItem) {
        labelTitle.text = model.title
        imageViewAccessory.isHidden = !model.haveAccessory
    }
    
}
