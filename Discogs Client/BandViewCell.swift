//
//  BandViewCell.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 25/01/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit

class BandViewCell: UITableViewCell {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
