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
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.button.setBackgroundImage(UIImage.init(imageLiteral: "highlighted"), forState: .Highlighted)
    }
    
    
    // MARK: - public
    
    func fillFrom(model model: Note) {
        self.titleLabel.text = model.name
    }
}
