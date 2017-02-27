//
//  MDPurchaseCell.swift
//  Moodles
//
//  Created by VladislavEmets on 12/13/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import WebImage

class MDPurchaseCell: UITableViewCell, CellProtocol {
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageViewSeparator: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewIcon.layer.cornerRadius = 5.0
    }
    
    func fillFrom(model: MDPurchase) {
        labelTitle.text = model.title
        labelDescription.text = model.textDescription
        model.getImageURL() { [weak self](url, error) in
            if let imageUrl = url {
                self?.imageViewIcon.sd_setImage(with: imageUrl)
            }
        }
    }
    
}
