//
//  AlbumTableViewCell.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 22/04/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    
    @IBOutlet weak var trackNumberLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
