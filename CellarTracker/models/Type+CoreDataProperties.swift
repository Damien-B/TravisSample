//
//  Type+CoreDataProperties.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 10/10/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreData
//import 

extension Type {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Type> {
        return NSFetchRequest<Type>(entityName: "Type");
    }

    @NSManaged public var value: String?
    @NSManaged public var ofBottle: NSSet?

}

// MARK: Generated accessors for ofBottle
extension Type {

    @objc(addOfBottleObject:)
    @NSManaged public func addToOfBottle(_ value: Bottle)

    @objc(removeOfBottleObject:)
    @NSManaged public func removeFromOfBottle(_ value: Bottle)

    @objc(addOfBottle:)
    @NSManaged public func addToOfBottle(_ values: NSSet)

    @objc(removeOfBottle:)
    @NSManaged public func removeFromOfBottle(_ values: NSSet)

}
