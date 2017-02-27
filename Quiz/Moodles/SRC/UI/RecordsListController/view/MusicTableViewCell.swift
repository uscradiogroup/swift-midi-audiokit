//
//  RecordsTableViewCell.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/15/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell, CellProtocol {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton?
    @IBOutlet weak var imageViewSeparator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - public
    
    func fillFrom(model: Music) {
        self.titleLabel.text = model.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
}
