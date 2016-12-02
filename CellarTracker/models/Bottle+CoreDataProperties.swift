//
//  Bottle+CoreDataProperties.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 10/10/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreData
//import 

extension Bottle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bottle> {
        return NSFetchRequest<Bottle>(entityName: "Bottle");
    }

    @NSManaged public var capacity: Double
    @NSManaged public var comment: String?
    @NSManaged public var count: Int16
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var year: Int16
    @NSManaged public var fromDomain: Domaine?
    @NSManaged public var cost: NSSet?
    @NSManaged public var isOfType: Type?

}

// MARK: Generated accessors for cost
extension Bottle {

    @objc(addCostObject:)
    @NSManaged public func addToCost(_ value: Price)

    @objc(removeCostObject:)
    @NSManaged public func removeFromCost(_ value: Price)

    @objc(addCost:)
    @NSManaged public func addToCost(_ values: NSSet)

    @objc(removeCost:)
    @NSManaged public func removeFromCost(_ values: NSSet)

}
