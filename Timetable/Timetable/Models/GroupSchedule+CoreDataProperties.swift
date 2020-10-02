//
//  GroupSchedule+CoreDataProperties.swift
//  TimeTable
//
//  Created by ar_ko on 25/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//
//

import CoreData


extension GroupSchedule {
    
    @NSManaged public var lastUpdate: Date?
    @NSManaged public var group: Group
    @NSManaged public var timetable: NSOrderedSet
    
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupSchedule> {
        return NSFetchRequest<GroupSchedule>(entityName: "GroupSchedule")
    }
}

// MARK: Generated accessors for timetable
extension GroupSchedule {

    
    @objc(insertObject:inTimetableAtIndex:)
    @NSManaged public func insertIntoTimetable(_ value: Day, at idx: Int)

    @objc(removeObjectFromTimetableAtIndex:)
    @NSManaged public func removeFromTimetable(at idx: Int)

    @objc(insertTimetable:atIndexes:)
    @NSManaged public func insertIntoTimetable(_ values: [Day], at indexes: NSIndexSet)

    @objc(removeTimetableAtIndexes:)
    @NSManaged public func removeFromTimetable(at indexes: NSIndexSet)

    @objc(replaceObjectInTimetableAtIndex:withObject:)
    @NSManaged public func replaceTimetable(at idx: Int, with value: Day)

    @objc(replaceTimetableAtIndexes:withTimetable:)
    @NSManaged public func replaceTimetable(at indexes: NSIndexSet, with values: [Day])

    @objc(addTimetableObject:)
    @NSManaged public func addToTimetable(_ value: Day)

    @objc(removeTimetableObject:)
    @NSManaged public func removeFromTimetable(_ value: Day)

    @objc(addTimetable:)
    @NSManaged public func addToTimetable(_ values: NSOrderedSet)

    @objc(removeTimetable:)
    @NSManaged public func removeFromTimetable(_ values: NSOrderedSet)

}
