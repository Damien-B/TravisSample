//
//  Domaine+CoreDataProperties.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 10/10/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreData
//import 

extension Domaine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Domaine> {
        return NSFetchRequest<Domaine>(entityName: "Domain");
    }

    @NSManaged public var name: String?
    @NSManaged public var location: String?
    @NSManaged public var country: String?
    @NSManaged public var includeBottle: NSSet?

}

// MARK: Generated accessors for includeBottle
extension Domaine {

    @objc(addIncludeBottleObject:)
    @NSManaged public func addToIncludeBottle(_ value: Bottle)

    @objc(removeIncludeBottleObject:)
    @NSManaged public func removeFromIncludeBottle(_ value: Bottle)

    @objc(addIncludeBottle:)
    @NSManaged public func addToIncludeBottle(_ values: NSSet)

    @objc(removeIncludeBottle:)
    @NSManaged public func removeFromIncludeBottle(_ values: NSSet)

}
