//
//  Price+CoreDataProperties.swift
//  CellarTracker
//
//  Created by Damien Bannerot on 10/10/2016.
//  Copyright © 2016 Damien Bannerot. All rights reserved.
//

import Foundation
import CoreData
//import 

extension Price {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Price> {
        return NSFetchRequest<Price>(entityName: "Price");
    }

    @NSManaged public var comment: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var value: Double
    @NSManaged public var ofBottle: Bottle?

}
