//
//  ViewController.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 29/09/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var bottlesTableView: UITableView!
	
	var manager: CoreDataManager?
	var bottlesArray: [Bottle] = []
	var selectedBottle: Bottle?
	var existingTypes: [Type] = []
	
	override func viewDidLoad() {
		
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidLoad()
		self.loadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: Helpers
	
	func loadData() {
		self.bottlesArray = CoreDataManager.shared.retrieveExistingBottles(ofType: CoreDataManager.shared.retrieveExistingTypes()[0])
		self.existingTypes = CoreDataManager.shared.retrieveExistingTypes()
		self.bottlesTableView.reloadData()

	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toDetailViewController" {
			if let bottle = self.selectedBottle {
				(segue.destination as! BottleDetailViewController).bottleObject = bottle
			}
		}
	}
	
	// MARK: UITableViewDataSource
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.existingTypes.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return CoreDataManager.shared.retrieveExistingBottles(ofType: self.existingTypes[section]).count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//TODO: relocate to custom cell class
		var cell = tableView.dequeueReusableCell(withIdentifier: "wineBottleTableViewCell") as? WineBottleTableViewCell
		if (cell == nil) {
			cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "wineBottleTableViewCell") as? WineBottleTableViewCell
		}
		
		let tmpBottle = CoreDataManager.shared.retrieveExistingBottles(ofType: self.existingTypes[indexPath.section])[indexPath.row]
//		print(self.bottlesArray[indexPath.row].name!)
		cell!.wineBottleNameLabel.text = "\(tmpBottle.name!), \(tmpBottle.year)"
		cell!.wineBottleCountLabel.text = "\(tmpBottle.count) 🍾"
		if tmpBottle.count == 0 {
			cell!.backgroundColor = UIColor.red
		} else {
			cell!.backgroundColor = UIColor.white
		}
		cell!.wineBottleImageView.image = UIImage.init(data: tmpBottle.image! as Data)
		
		// TODO: rename outlet
		
		if let prices = tmpBottle.cost {
			let pricesArray = prices.allObjects
			cell!.wineBottleTypeLabel.text = "\((pricesArray.last as! Price).value) €"
		}
		
		if let domain = tmpBottle.fromDomain {
			cell!.wineBottleDomainLabel.text = domain.name!
		} else {
			cell!.wineBottleDomainLabel.text = ""
		}
//		if let type = tmpBottle.isOfType {
//			cell!.wineBottleTypeLabel.text = type.value!
//		} else {
//			cell!.wineBottleTypeLabel.text = ""
//		}
		
		return cell!
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.existingTypes[section].value!
	}
	
	// MARK: UITableViewDelegate
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return UITableViewCellEditingStyle.delete
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		// CoreData deletion
		CoreDataManager.shared.managedObjectContext.delete(CoreDataManager.shared.retrieveExistingBottles(ofType: self.existingTypes[indexPath.section])[indexPath.row])
		try! CoreDataManager.shared.managedObjectContext.save()
		tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
		self.loadData()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedBottle = CoreDataManager.shared.retrieveExistingBottles(ofType: self.existingTypes[indexPath.section])[indexPath.row]
		self.performSegue(withIdentifier: "toDetailViewController", sender: self)
	}
	
}

