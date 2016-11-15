//
//  ExampleTableViewCell.swift
//  ExampleMIDI
//
//  Created by Artem Chabannyi on 10/24/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit

class ExampleTableViewCell: UITableViewCell, CellProtocol {

    @IBOutlet var titleLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillFrom(model model: ExampleModel) {
        self.titleLabel?.text  = model.title
    }

}
