//
//  CoreDataManager.swift
//  TimeTable
//
//  Created by ar_ko on 06.10.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    lazy var persistenrContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CoreDataTimetable")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return persistentContainer
    }()
    
    var context: NSManagedObjectContext {
        persistenrContainer.viewContext
    }
    
    func getTimetable(for groupSchedule: GroupSchedule, completion: @escaping() -> ()) {
        TimetableNetworkService.getTimetable(group: groupSchedule.group, context: context) { [self] (response) in
            if let response = response {
                groupSchedule.timetable = NSOrderedSet(array: response.timetable)
                groupSchedule.lastUpdate = Date()
                
                do {
                    try self.context.save()
                    print("[INFO] Timetable updated and saved")
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("[INFO] Timetable loaded from cache")
                completion()
            }
        }
    }
    
    func printGroupSchelduesCount() {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        do {
            let result = try self.context.fetch(fetchRequest)
            print("GroupSchedules count: \(result.count)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadGroupScheldule(profile groupProfile: String, course groupCourse: String) -> GroupSchedule? {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name == %@ AND group.course == %@", argumentArray: [groupProfile, groupCourse])
        do {
            let result = try self.context.fetch(fetchRequest)
            if result.count > 0 {
                return result.first
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func clearCoreDataExcept(profile groupProfile: String, course groupCourse: String) {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name != %@ || group.course != %@", groupProfile, groupCourse)
        
        do {
            let result = try self.context.fetch(fetchRequest)
            for res in result {
                self.context.delete(res)
            }
            try self.context.save()
            print("[INFO] Cleared the groups cache")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func selectGroup(profile groupProfile: String, course groupCourse: String, groupList groups: [Group]) {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name == %@ AND group.course == %@", argumentArray: [groupProfile, groupCourse])
        do {
            let result = try self.context.fetch(fetchRequest)
            if result.count == 0 {
                let groupSchedule = GroupSchedule(context: self.context)
                let groupp = groups.filter {$0.name == groupProfile && $0.course == groupCourse}.first
                guard let group = groupp else { return }
                groupSchedule.group = group
                groupSchedule.timetable = NSOrderedSet(array: [Day]())
                groupSchedule.lastUpdate = nil
                try self.context.save()
                print("[INFO] Created new group")
            }
            else {
                print("[INFO] Loaded group from cache")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
