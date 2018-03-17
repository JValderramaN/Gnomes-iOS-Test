//
//  ThumbnailTableViewCell.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit
import SDWebImage

let thumbnailCellIdentifier = "ThumbnailTableViewCell"

class ThumbnailTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillData(with thumbnailURL: URL?) {
        thumbnailImageView.sd_setImage(with: thumbnailURL, placeholderImage: #imageLiteral(resourceName: "gnome"))
    }
}
