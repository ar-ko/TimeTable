//
//  CoreDataStorage.swift
//  TimeTable
//
//  Created by ar_ko on 13/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import CoreData


internal struct CoreDataStorage {
    
    
    func getTimeTable(for groupSchedule: GroupSchedule, in context: NSManagedObjectContext, completion: @escaping() -> ()) {
        TimeTableNetworkService.getTimeTable(group: groupSchedule.group, context: context) { (response) in
            if let response = response {
                groupSchedule.timeTable = NSOrderedSet(array: response.timetable)
                groupSchedule.lastUpdate = Date()
                
                do {
                    try context.save()
                    print("TimeTable load and saved!")
                    completion()
                } catch {
                    print(error)
                }
            }
            else {
                print("TimeTable load from cash")
                completion()
            }
        }
    }
    
    func printGroupSchelduesCount(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            print("GroupSchedules count: \(result.count)")
        } catch {
            print(error)
        }
    }
    
    func loadGroupScheldule(profile groupProfile: String, curse groupCurse: String, in context: NSManagedObjectContext) -> GroupSchedule? {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name == %@ AND group.curse == %@", argumentArray: [groupProfile, groupCurse])
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                return result.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func clearCoreDataExcept(profile groupProfile: String, curse groupCurse: String, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name != %@ || group.curse != %@", groupProfile, groupCurse)
        
        do {
            let result = try context.fetch(fetchRequest)
            for res in result {
                context.delete(res)
            }
            try context.save()
            print("Groups deleted!")
        } catch {
            print(error)
        }
    }
    
    func selectGroup(profile groupProfile: String, curse groupCurse: String, groupList groups: [Group], in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name == %@ AND group.curse == %@", argumentArray: [groupProfile, groupCurse])
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0 {
                let groupSchedule = GroupSchedule(context: context)
                groupSchedule.group = groups.filter {$0.name == groupProfile && $0.curse == groupCurse}.first!
                groupSchedule.timeTable = NSOrderedSet(array: [Day]())
                groupSchedule.lastUpdate = nil
                try context.save()
                print("New group create!")
            }
        } catch {
            print(error)
        }
    }
}
