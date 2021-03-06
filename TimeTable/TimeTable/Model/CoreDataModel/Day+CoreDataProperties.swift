//
//  Day+CoreDataProperties.swift
//  TimeTable
//
//  Created by ar_ko on 25/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//
//

import CoreData


extension Day {

    @NSManaged public var lessons: NSOrderedSet?
    @NSManaged public var timeTable: GroupSchedule?
    
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }
}

// MARK: Generated accessors for lessons
extension Day {

    
    @objc(insertObject:inLessonsAtIndex:)
    @NSManaged public func insertIntoLessons(_ value: Lesson, at idx: Int)

    @objc(removeObjectFromLessonsAtIndex:)
    @NSManaged public func removeFromLessons(at idx: Int)

    @objc(insertLessons:atIndexes:)
    @NSManaged public func insertIntoLessons(_ values: [Lesson], at indexes: NSIndexSet)

    @objc(removeLessonsAtIndexes:)
    @NSManaged public func removeFromLessons(at indexes: NSIndexSet)

    @objc(replaceObjectInLessonsAtIndex:withObject:)
    @NSManaged public func replaceLessons(at idx: Int, with value: Lesson)

    @objc(replaceLessonsAtIndexes:withLessons:)
    @NSManaged public func replaceLessons(at indexes: NSIndexSet, with values: [Lesson])

    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSOrderedSet)

    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSOrderedSet)

}
