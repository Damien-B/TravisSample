//
//  BottleDetailViewController.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 18/10/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import UIKit

class BottleDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	
	@IBOutlet weak var bottleImageView: UIImageView!
	@IBOutlet weak var bottleDomainNameLabel: UILabel!
	@IBOutlet weak var bottleDomainLocationLabel: UILabel!
	@IBOutlet weak var bottleNameLabel: UILabel!
	@IBOutlet weak var bottleYearLabel: UILabel!
	@IBOutlet weak var bottleTypeLabel: UILabel!
	@IBOutlet weak var bottleCapacityLabel: UILabel!
	@IBOutlet weak var bottleCountLabel: UILabel!
	@IBOutlet weak var bottleCountStepper: UIStepper!
	@IBOutlet weak var bottlePricesTableView: UITableView!
	
	@IBOutlet weak var priceTableViewHeightConstraint: NSLayoutConstraint!
	
	let priceTableViewCellHeight: CGFloat = 44
	var bottleObject: Bottle?
	
    override func viewDidLoad() {
		super.viewDidLoad()
		self.loadData()
    }
	
	override func viewDidAppear(_ animated: Bool) {
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		// CoreData update
		try! CoreDataManager.shared.managedObjectContext.save()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Actions
	
	@IBAction func clickOnCountStepper(_ sender: UIStepper) {
		self.bottleObject?.count = Int16(sender.value)
		if sender.value > 1 {
			self.bottleCountLabel.text = "\(Int(sender.value)) bouteilles"
		} else {
			self.bottleCountLabel.text = "\(Int(sender.value)) bouteille"
		}
	}
	
	
	// MARK: Helpers

	func loadData() {
		if let bottle = self.bottleObject {
			self.bottleImageView.image = UIImage.init(data: bottle.image! as Data)
			if let domain = bottle.fromDomain {
				if let domainName = domain.name {
					self.bottleDomainNameLabel.text = domainName
				} else {
					self.bottleDomainNameLabel.text = ""
				}
				if let domainCountry = domain.country {
					if let domainLocation = domain.location {
						self.bottleDomainLocationLabel.text = "\(domainLocation), \(domainCountry)"
					} else {
						self.bottleDomainLocationLabel.text = domainCountry
					}
				} else {
					self.bottleDomainLocationLabel.text = ""
				}
			} else {
				self.bottleDomainNameLabel.text = ""
				self.bottleDomainLocationLabel.text = ""
			}
			self.bottleNameLabel.text = bottle.name
			self.title = bottle.name
			self.bottleYearLabel.text = "\(bottle.year)"
			if let type = bottle.isOfType {
				self.bottleTypeLabel.text = type.value
			} else {
				self.bottleTypeLabel.text = ""
			}
			self.bottleCapacityLabel.text = "\(bottle.capacity) cl"
			if bottle.count > 1 {
				self.bottleCountLabel.text = "\(bottle.count) bouteilles"
			} else {
				self.bottleCountLabel.text = "\(bottle.count) bouteille"
			}
			self.bottleCountStepper.value = Double(bottle.count)
		} else {
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	// MARK: UITableViewDataSource
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.priceTableViewCellHeight
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let bottle = self.bottleObject {
			if let prices = bottle.cost {
				self.priceTableViewHeightConstraint.constant = CGFloat(prices.count)*self.priceTableViewCellHeight
				return prices.count
			}
		}
			return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//TODO: relocate to custom cell class
		var cell = tableView.dequeueReusableCell(withIdentifier: "priceTableViewCell") as? CustomPriceTableViewCell
		if (cell == nil) {
			cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "priceTableViewCell") as? CustomPriceTableViewCell
		}
		if let bottle = self.bottleObject {
			if let prices = bottle.cost {
				let pricesArray = prices.allObjects
				cell?.priceValueLabel.text = "\((pricesArray[indexPath.row] as! Price).value)€"
				let formatter = DateFormatter()
				formatter.dateStyle = .short
				cell?.priceDateLabel.text = formatter.string(from: (pricesArray[indexPath.row] as! Price).timestamp as! Date)
				if let comment = (pricesArray[indexPath.row] as! Price).comment {
					cell?.priceCommentLabel.text = comment
				}
			}
		}
		
		return cell!
	}

}
