//
//  Lesson+CoreDataProperties.swift
//  TimeTable
//
//  Created by ar_ko on 25/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//
//

import CoreData


extension Lesson {
    
    @NSManaged public var startTime: Date
    var endTime: Date {
        get {
            let lessonDuration: Double = 5400 // в секундах
            return startTime.addingTimeInterval(lessonDuration)
        }
    }
    
    @NSManaged public var title: String?
    @NSManaged public var teacherName: String?
    
    @NSManaged public var typeRaw: Int16
    var type: LessonType? {
        set { self.typeRaw = Int16(newValue!.rawValue) }
        get { return LessonType(rawValue: Int(typeRaw))! }
    }
    
    @NSManaged public var formRaw: Int16
    var form: LessonForm? {
        set { self.formRaw = Int16(newValue!.rawValue) }
        get { return LessonForm(rawValue: Int(formRaw))! }
    }
    
    @NSManaged public var subgroupRaw: Int16
    var subgroup: Subgroup? {
        set { self.subgroupRaw = Int16(newValue!.rawValue) }
        get { return Subgroup(rawValue: Int(subgroupRaw))! }
    }
    
    @NSManaged public var note: String?
    @NSManaged public var locations: NSOrderedSet?
    @NSManaged public var otherCabinet: Bool
    @NSManaged public var otherCampus: Bool
    
    @NSManaged public var day: Day?
    
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }
}

enum LessonForm: Int {case none, standart, online, canceled}
enum Subgroup: Int {case none, first, second, general}
enum LessonType: Int {case none, lecture, practice, laboratory}


// MARK: Generated accessors for locations
extension Lesson {
    
    
    @objc(insertObject:inLocationsAtIndex:)
    @NSManaged public func insertIntoLocations(_ value: Location, at idx: Int)
    
    @objc(removeObjectFromLocationsAtIndex:)
    @NSManaged public func removeFromLocations(at idx: Int)
    
    @objc(insertLocations:atIndexes:)
    @NSManaged public func insertIntoLocations(_ values: [Location], at indexes: NSIndexSet)
    
    @objc(removeLocationsAtIndexes:)
    @NSManaged public func removeFromLocations(at indexes: NSIndexSet)
    
    @objc(replaceObjectInLocationsAtIndex:withObject:)
    @NSManaged public func replaceLocations(at idx: Int, with value: Location)
    
    @objc(replaceLocationsAtIndexes:withLocations:)
    @NSManaged public func replaceLocations(at indexes: NSIndexSet, with values: [Location])
    
    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)
    
    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)
    
    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSOrderedSet)
    
    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSOrderedSet)
    
}
