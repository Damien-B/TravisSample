//
//  WineBottleTableViewCell.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 29/09/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import UIKit

class WineBottleTableViewCell: UITableViewCell {
	
	@IBOutlet weak var wineBottleImageView: UIImageView!
	@IBOutlet weak var wineBottleDomainLabel: UILabel!
	@IBOutlet weak var wineBottleNameLabel: UILabel!
	@IBOutlet weak var wineBottleCountLabel: UILabel!
	@IBOutlet weak var wineBottleTypeLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func initCell(with bottle: Bottle) {
//		if let imageData = bottle.image {
//			self.wineBottleImageView.image = UIImage(data: (imageData as Data))
//		} else {}
//		if let domain = bottle.bottleDomaine {
//			self.wineBottleDomainLabel.text = domain.name
//		} else {}
//		if let name = bottle.name {
//			self.wineBottleNameLabel.text = name
//		} else {}
//		self.wineBottleDomainLabel.text = String(bottle.count)
	}

}
