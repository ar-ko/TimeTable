//
//  Location+CoreDataProperties.swift
//  TimeTable
//
//  Created by ar_ko on 25/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//
//

import CoreData

extension Location {
    @NSManaged public var cabinet: String?
    @NSManaged public var campus: String?
    
    @NSManaged public var lesson: Lesson?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
}
