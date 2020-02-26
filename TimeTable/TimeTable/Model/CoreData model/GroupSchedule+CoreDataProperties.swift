//
//  GroupSchedule+CoreDataProperties.swift
//  TimeTable
//
//  Created by ar_ko on 25/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//
//

import Foundation
import CoreData


extension GroupSchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupSchedule> {
        return NSFetchRequest<GroupSchedule>(entityName: "GroupSchedule")
    }

    @NSManaged public var lastUpdate: Date
    @NSManaged public var group: Group
    @NSManaged public var timeTable: NSOrderedSet
}

// MARK: Generated accessors for timeTable
extension GroupSchedule {

    @objc(insertObject:inTimeTableAtIndex:)
    @NSManaged public func insertIntoTimeTable(_ value: Day, at idx: Int)

    @objc(removeObjectFromTimeTableAtIndex:)
    @NSManaged public func removeFromTimeTable(at idx: Int)

    @objc(insertTimeTable:atIndexes:)
    @NSManaged public func insertIntoTimeTable(_ values: [Day], at indexes: NSIndexSet)

    @objc(removeTimeTableAtIndexes:)
    @NSManaged public func removeFromTimeTable(at indexes: NSIndexSet)

    @objc(replaceObjectInTimeTableAtIndex:withObject:)
    @NSManaged public func replaceTimeTable(at idx: Int, with value: Day)

    @objc(replaceTimeTableAtIndexes:withTimeTable:)
    @NSManaged public func replaceTimeTable(at indexes: NSIndexSet, with values: [Day])

    @objc(addTimeTableObject:)
    @NSManaged public func addToTimeTable(_ value: Day)

    @objc(removeTimeTableObject:)
    @NSManaged public func removeFromTimeTable(_ value: Day)

    @objc(addTimeTable:)
    @NSManaged public func addToTimeTable(_ values: NSOrderedSet)

    @objc(removeTimeTable:)
    @NSManaged public func removeFromTimeTable(_ values: NSOrderedSet)

}
