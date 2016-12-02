//
//  BottleCreationViewController.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 17/10/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import UIKit
import CoreData

class BottleCreationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var parentView: UIView!
	
	@IBOutlet weak var bottleImageView: UIImageView!
	@IBOutlet weak var bottleNameTextField: UITextField!
	@IBOutlet weak var bottleCapacityTextField: UITextField!
	@IBOutlet weak var bottleCommentTextView: UITextView!
	@IBOutlet weak var bottleCountStepper: UIStepper!
	@IBOutlet weak var bottleCountFeedbackLabel: UILabel!
	@IBOutlet weak var bottleYearPicker: UIPickerView!
	@IBOutlet weak var bottleTypePicker: UIPickerView!
	@IBOutlet weak var bottleTypeAddButton: UIButton!
	@IBOutlet weak var bottleDomainPicker: UIPickerView!
	@IBOutlet weak var bottleDomainAddButton: UIButton!
	@IBOutlet weak var bottlePriceTextField: UITextField!
	@IBOutlet weak var bottlePriceCommentTextView: UITextView!
	
	@IBOutlet weak var parentViewBottomConstraint: NSLayoutConstraint!
	
	let bottleYearDatePickerLowRange: Int = 1900
	var currentYear: Int = 2000
	
	var existingTypes: [Type] = []
	var existingDomains: [Domaine] = []
	
	var imageSetted: Bool = false
	
	var typeTextField: UITextField?
	var domainNameTextField: UITextField?
	var domainLocationTextField: UITextField?
	var domainCountryTextField: UITextField?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(BottleCreationViewController.keyboardAppeared), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(BottleCreationViewController.keyboardDismissed), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		self.loadDatas()
		self.bottleTypeAddButton.titleLabel?.textAlignment = NSTextAlignment.center
		self.bottleDomainAddButton.titleLabel?.textAlignment = NSTextAlignment.center
    }
	
	func loadDatas() {
		let date = Date()
		let calendar = NSCalendar.current
		self.currentYear = calendar.component(.year, from: date)
		self.existingTypes = CoreDataManager.shared.retrieveExistingTypes()
		self.existingDomains = CoreDataManager.shared.retrieveExistingDomains()
		self.bottleYearPicker.reloadAllComponents()
		self.bottleDomainPicker.reloadAllComponents()
		self.bottleTypePicker.reloadAllComponents()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Actions
	
	@IBAction func clickOnStepper(_ sender: UIStepper) {
		if sender.value > 1 {
			self.bottleCountFeedbackLabel.text = "\(Int(sender.value)) bouteilles"
		} else {
			self.bottleCountFeedbackLabel.text = "\(Int(sender.value)) bouteille"
		}
	}
	
	@IBAction func addTypeButtonClicked(_ sender: UIButton) {
		let typeAlert = UIAlertController(title: "ajouter un type de vin", message: nil, preferredStyle: UIAlertControllerStyle.alert)
		typeAlert.addTextField { (valueTextField) in
			valueTextField.placeholder = "ex: vin rouge"
			self.typeTextField = valueTextField
		}
		typeAlert.addAction(UIAlertAction(title: "ajouter", style: UIAlertActionStyle.default, handler: { (action) in
			// CoreData type creation
			let typeEntityDescription = NSEntityDescription.entity(forEntityName: "Type", in: CoreDataManager.shared.managedObjectContext)
			let newType = NSManagedObject.init(entity: typeEntityDescription!, insertInto: CoreDataManager.shared.managedObjectContext) as! Type
			if let typeTF = self.typeTextField {
				newType.value = typeTF.text!
				try! CoreDataManager.shared.managedObjectContext.save()
				self.loadDatas()
				self.bottleTypePicker.selectRow(self.existingTypes.count-1, inComponent: 0, animated: true)
			}
		}))
		typeAlert.addAction(UIAlertAction(title: "annuler", style: UIAlertActionStyle.cancel, handler: nil))
		self.present(typeAlert, animated: true, completion: nil)
	}
	
	@IBAction func addDomainButtonClicked(_ sender: UIButton) {
		let domainAlert = UIAlertController(title: "ajouter un domaine", message: nil, preferredStyle: UIAlertControllerStyle.alert)
		domainAlert.addTextField { (nameTextField) in
			nameTextField.placeholder = "name"
			self.domainNameTextField = nameTextField
		}
		domainAlert.addTextField { (countryTextField) in
			countryTextField.placeholder = "pays (ex: France 🇫🇷)"
			self.domainCountryTextField = countryTextField
		}
		domainAlert.addTextField { (locationTextField) in
			locationTextField.placeholder = "lieu (ex: Bourgogne)"
			self.domainLocationTextField = locationTextField
		}
		domainAlert.addAction(UIAlertAction(title: "ajouter", style: UIAlertActionStyle.default, handler: { (action) in
			// CoreData domain creation
			let DomainEntityDescription = NSEntityDescription.entity(forEntityName: "Domain", in: CoreDataManager.shared.managedObjectContext)
			let newDomain = NSManagedObject.init(entity: DomainEntityDescription!, insertInto: CoreDataManager.shared.managedObjectContext) as! Domaine
			if let nameTF = self.domainNameTextField, let countryTF = self.domainCountryTextField, let locationTF = self.domainNameTextField {
				newDomain.name = nameTF.text!
				newDomain.country = countryTF.text!
				newDomain.location = locationTF.text!
				try! CoreDataManager.shared.managedObjectContext.save()
				self.loadDatas()
				self.bottleDomainPicker.selectRow(self.existingDomains.count-1, inComponent: 0, animated: true)
			}
		}))
		domainAlert.addAction(UIAlertAction(title: "annuler", style: UIAlertActionStyle.cancel, handler: nil))
		self.present(domainAlert, animated: true, completion: nil)

	}
	
	@IBAction func tapOnBottleImageView(_ sender: AnyObject) {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
			// TODO: ajouter une alert view pour choix entre photo & library
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
			imagePicker.allowsEditing = false
			self.present(imagePicker, animated: true, completion: nil)
		} else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
			imagePicker.allowsEditing = false
			self.present(imagePicker, animated: true, completion: nil)
		} else {
			self.imageSetted = true
		}
	}
	
	@IBAction func dismissKeyboard(_ sender: AnyObject) {
		self.view.endEditing(true)
	}
	
	// TODO: ajouter des restrictions pour les inputs (+ feedback)
	@IBAction func saveBottleObject(_ sender: AnyObject) {
		self.checkIfInputsAreFilled { (error) in
			if let error = error {
				let alert = UIAlertController(title: "Une erreur est survenue", message: error, preferredStyle: UIAlertControllerStyle.alert)
				alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
				self.present(alert, animated: true, completion: nil)
			} else {
				// CoreData bottle creation
				let bottleEntityDescription = NSEntityDescription.entity(forEntityName: "Bottle", in: CoreDataManager.shared.managedObjectContext)
				let newBottle = NSManagedObject.init(entity: bottleEntityDescription!, insertInto: CoreDataManager.shared.managedObjectContext) as! Bottle
				newBottle.capacity = Double(self.bottleCapacityTextField.text!)!
				newBottle.count = Int16(Int(self.bottleCountStepper.value))
				newBottle.comment = self.bottleCommentTextView.text
				newBottle.image = UIImageJPEGRepresentation(self.bottleImageView.image!, CGFloat(1))! as Data as NSData?
				newBottle.year = Int16(self.currentYear - self.bottleYearPicker.selectedRow(inComponent: 0))
				newBottle.name = self.bottleNameTextField.text
				
				if self.existingDomains.count > 0 {
					let domain = self.existingDomains[self.bottleDomainPicker.selectedRow(inComponent: 0)]
					domain.includeBottle?.adding(newBottle)
					
					newBottle.fromDomain = domain
				}
				if self.existingTypes.count > 0 {
					let type = self.existingTypes[self.bottleTypePicker.selectedRow(inComponent: 0)]
					type.ofBottle?.adding(newBottle)
					
					newBottle.isOfType = type
				}
				// CoreData price creation
				let priceEntityDescription = NSEntityDescription.entity(forEntityName: "Price", in: CoreDataManager.shared.managedObjectContext)
				let newPrice = NSManagedObject.init(entity: priceEntityDescription!, insertInto: CoreDataManager.shared.managedObjectContext) as! Price
				newPrice.value = Double(self.bottlePriceTextField.text!.replacingOccurrences(of: ",", with: "."))!
				newPrice.comment = self.bottlePriceCommentTextView.text
				newPrice.timestamp = NSDate()
				newPrice.ofBottle = newBottle
				
				try! CoreDataManager.shared.managedObjectContext.save()
				// TODO: check why this is not working
				self.dismiss(animated: true, completion: nil)
				let successAlert = UIAlertController(title: "bouteille ajouté avec succès !", message: nil, preferredStyle: UIAlertControllerStyle.alert)
				successAlert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
				self.present(successAlert, animated: true, completion: nil)
			}
		}
		self.loadDatas()
	}
	
	// MARK: Helpers
	
	func keyboardAppeared(notification: NSNotification) {
		if let userInfo = notification.userInfo {
			let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
			UIView.animate(withDuration: 0.2, animations: {
				self.parentViewBottomConstraint.constant = keyboardHeight
				self.parentView.layoutIfNeeded()
			});
//			self.scrollView.scrollRectToVisible(CGRect.init(x: 0, y: self.scrollView.contentOffset.y+keyboardHeight, width: self.scrollView.frame.width, height: self.scrollView.frame.height), animated: true)
		}
		
	}
	
	func keyboardDismissed(notification: NSNotification) {
		self.parentViewBottomConstraint.constant = 0
	}
	
	func checkIfInputsAreFilled(completion: (_ error: String?)->Void) {
		if self.bottleNameTextField.text == "" {
			completion("Vous devez fournir un nom !")
		} else if self.bottleImageView.image == nil {
			completion("Vous devez fournir une image !")
		} else if self.bottleCapacityTextField.text == "" {
			completion("Le champ capacité doit être rempli !")
		} else if self.bottlePriceTextField.text == "" {
			completion("Vous devez fournir un prix !")
		} else if !self.imageSetted {
			completion("Vous devez fournir une image !")
		}
		completion(nil)
	}
	
	// MARK: UIPickerViewDataSource
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == self.bottleTypePicker {
			if self.existingTypes.count > 0 {
				return self.existingTypes.count
			}
			return 1
		} else if pickerView == self.bottleDomainPicker {
			if self.existingDomains.count > 0 {
				return self.existingDomains.count
			}
			return 1
		} else if pickerView == self.bottleYearPicker {
			return self.currentYear - self.bottleYearDatePickerLowRange - 1
		}
		return 1
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == self.bottleTypePicker {
			if self.existingTypes.count > 0 {
				return self.existingTypes[row].value!
			}
			return "pas de type"
		} else if pickerView == self.bottleDomainPicker {
			if self.existingDomains.count > 0 {
				return self.existingDomains[row].name!
			}
			return "pas de domaine"
		} else if pickerView == self.bottleYearPicker {
			return "\(self.currentYear - row)"
		}
		return "item n°\(row)"
	}
	
	// reduce font size
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		
		var pickerLabel = view as? UILabel
		
		if (pickerLabel == nil)
		{
			pickerLabel = UILabel()
			
			pickerLabel!.font = UIFont.systemFont(ofSize: 14)
			pickerLabel!.textAlignment = NSTextAlignment.center
		}
		if pickerView == self.bottleTypePicker {
			if self.existingTypes.count > 0 {
				pickerLabel!.text = self.existingTypes[row].value!
			} else {
				pickerLabel!.text = "pas de type"
			}
		} else if pickerView == self.bottleDomainPicker {
			if self.existingDomains.count > 0 {
				pickerLabel!.text = self.existingDomains[row].name!
			} else {
				pickerLabel!.text = "pas de domaine"
			}
		} else if pickerView == self.bottleYearPicker {
			pickerLabel!.text = "\(self.currentYear - row)"
		}
		return pickerLabel!
	}
	
	// MARK: UIPickerViewDelegate

//	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//		print("row n°\(row) selected")
//	}

	// MARK: UITextFieldDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.resignFirstResponder()
		return true
	}
	
	// MARK: UIImagePickerControllerDelegate
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			self.bottleImageView.image = image
			self.imageSetted = true
		}
		self.dismiss(animated: true)
	}
	
	
}
