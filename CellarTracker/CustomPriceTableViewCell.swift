//
//  CustomPriceTableViewCell.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 18/10/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import UIKit

class CustomPriceTableViewCell: UITableViewCell {

	@IBOutlet weak var priceValueLabel: UILabel!
	@IBOutlet weak var priceDateLabel: UILabel!
	@IBOutlet weak var priceCommentLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
