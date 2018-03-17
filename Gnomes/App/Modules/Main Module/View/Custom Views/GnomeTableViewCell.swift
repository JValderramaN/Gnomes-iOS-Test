//
//  GnomeTableViewCell.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit
import SDWebImage

let gnomeCellIdentifier = "GnomeTableViewCell"

class GnomeTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var ageLabel: UILabel!
    @IBOutlet fileprivate weak var weightLabel: UILabel!
    @IBOutlet fileprivate weak var heightLabel: UILabel!
    @IBOutlet fileprivate weak var hairColorLabel: UILabel!
    @IBOutlet fileprivate weak var professionsLabel: UILabel!
    @IBOutlet fileprivate weak var friendsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillData(with gnome: Gnome) {
        if let gnomeThumbnail = gnome.thumbnail, let thumbnailURL = URL(string: gnomeThumbnail) {
            thumbnailImageView.sd_setImage(with: thumbnailURL, placeholderImage: #imageLiteral(resourceName: "gnome"))
        }
        
        nameLabel.text = "Name: \(gnome.name ?? "")"
        ageLabel.text = "Age: \(gnome.age ?? 0)"
        weightLabel.text = "Weight: \(gnome.weight ?? 0)"
        heightLabel.text = "Height: \(gnome.height ?? 0)"
        hairColorLabel.text = "Hair color: \(gnome.hairColor ?? "")"
        professionsLabel.text = "Professions: \(gnome.professions?.count ?? 0)"
        friendsLabel.text = "Friends: \(gnome.friends?.count ?? 0)"
    }
}
