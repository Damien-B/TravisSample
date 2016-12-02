//
//  CoreDataManager.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 29/09/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

//import UIKit
import CoreData

class CoreDataManager: NSObject {
	
	let defaultTypes: [[String: String]] = [
		["value": "vin rouge"],
		["value": "vin blanc"],
		["value": "vin rosé"]
	]
	
	static let shared = CoreDataManager()
	
	var managedObjectContext: NSManagedObjectContext
	
	override init() {
		let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let storageURL = documentURL.appendingPathComponent("cellar.db")
		let modelURL = Bundle.main.url(forResource: "CellarTracker", withExtension: "momd")
		let model = NSManagedObjectModel(contentsOf: modelURL!)
		let store = NSPersistentStoreCoordinator(managedObjectModel: model!)
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		do {
			try store.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storageURL, options: nil)
			context.persistentStoreCoordinator = store
		} catch {
			print("error creating core data store")
		}
		self.managedObjectContext = context
		
		super.init()
	}
	
	func createDefaultDatasIfNecessary() {
		let typeRequest: NSFetchRequest<Type> = Type.fetchRequest()
		do {
			let types = try self.managedObjectContext.fetch(typeRequest) as [Type]
			if types.count == 0 {// no types in core data
				for type in self.defaultTypes {
					// create default types
					//DEBUG
					print("creating default types")
					let typeEntityDescription = NSEntityDescription.entity(forEntityName: "Type", in: self.managedObjectContext)
					let newType = NSManagedObject.init(entity: typeEntityDescription!, insertInto: self.managedObjectContext) as! Type
					newType.value = type["value"]
					try! self.managedObjectContext.save()
				}
			} else {
				//DEBUG
//				print(types)
			}
		} catch {
			print("error fetching types")
		}
	}
	
	func retrieveExistingDomains() -> [Domaine] {
		var domainsArray: [Domaine] = []
		let domainRequest: NSFetchRequest<Domaine> = Domaine.fetchRequest()
		do {
			let domains = try self.managedObjectContext.fetch(domainRequest) as [Domaine]
			if domains.count > 0 {
				for domain in domains {
					domainsArray.append(domain)
				}
			} else {//DEBUG
				print("no existing domain")
			}
		} catch {
			print("error fetching domains")
		}
		return domainsArray
	}
	
	func retrieveExistingTypes() -> [Type] {
		var typesArray: [Type] = []
		let typeRequest: NSFetchRequest<Type> = Type.fetchRequest()
		do {
			let types = try self.managedObjectContext.fetch(typeRequest) as [Type]
			if types.count > 0 {
				for type in types {
					typesArray.append(type)
				}
			} else {//DEBUG
				print("no existing type")
			}
		} catch {
			print("error fetching types")
		}
		return typesArray
	}
	
	func retrieveExistingBottles() -> [Bottle] {
		var bottlesArray: [Bottle] = []
		let bottleRequest: NSFetchRequest<Bottle> = Bottle.fetchRequest()
		// commented for accessing bottles with 0 (count)
		//		bottleRequest.predicate = NSPredicate(format: "count > 0")
		do {
			let bottles = try self.managedObjectContext.fetch(bottleRequest) as [Bottle]
			if bottles.count > 0 {
				for bottle in bottles {
					bottlesArray.append(bottle)
				}
			} else {//DEBUG
				print("no existing type")
			}
		} catch {
			print("error fetching types")
		}
		return bottlesArray
	}
	
	func retrieveExistingBottles(ofType type: Type) -> [Bottle] {
		var bottlesArray: [Bottle] = []
		let bottleRequest: NSFetchRequest<Bottle> = Bottle.fetchRequest()
		bottleRequest.predicate = NSPredicate(format: "isOfType == %@", type)
		do {
			let bottles = try self.managedObjectContext.fetch(bottleRequest) as [Bottle]
			if bottles.count > 0 {
				for bottle in bottles {
					bottlesArray.append(bottle)
				}
			} else {//DEBUG
				print("no existing type")
			}
		} catch {
			print("error fetching types")
		}
		return bottlesArray
	}
	
	

	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = NSPersistentContainer(name: "CellarTracker")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
}
