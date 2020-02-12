//
//  CDGroupSchedule+CoreDataProperties.swift
//  TimeTable
//
//  Created by ar_ko on 12/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//
//

import Foundation
import CoreData


extension CDGroupSchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDGroupSchedule> {
        return NSFetchRequest<CDGroupSchedule>(entityName: "CDGroupSchedule")
    }

    @NSManaged public var lastUpdate: Date?
    @NSManaged public var groupInfo: NSObject?
    @NSManaged public var timeTable: NSObject?

}
