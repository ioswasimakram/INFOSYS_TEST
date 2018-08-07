//
//  CountryDetailTableViewCell.swift
//  INFOSYS_TEST
//
//  Created by wasim akram on 05/08/18.
//  Copyright © 2018 Mohammad. All rights reserved.
//

import UIKit

class CountryDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
