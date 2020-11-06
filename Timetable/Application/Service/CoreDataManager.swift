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
    
    func createGroup() -> Group {
        let group = Group(context: context)
        group.startRow = 11
        group.startColumn = "J"
        group.endRow = 179
        group.endColumn = "M"
        group.sheetId = "%D0%9F%D0%A0%D0%9E%D0%A4%D0%AB"
        group.spreadsheetId = "12RJCSj430oow-Q5GnEHr7Wbww5vztZYLdUJSg_khrKA"
        return group
    }
    
    func getTimetable(for groupSchedule: GroupSchedule, completion: @escaping() -> ()) {
        
        
        TimetableNetworkService.getTimetable(group: groupSchedule.group, context: context) { [self] (response) in
            if let response = response {
                groupSchedule.timetable = NSOrderedSet(array: response.timetable)
                groupSchedule.lastUpdate = Date()
                
                do {
                    try self.context.save()
                    print("Timetable updated and saved!")
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("Timetable load from cash")
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
    
    func loadGroupScheldule(profile groupProfile: String, curse groupCurse: String) -> GroupSchedule? {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name == %@ AND group.curse == %@", argumentArray: [groupProfile, groupCurse])
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
    
    func clearCoreDataExcept(profile groupProfile: String, curse groupCurse: String) {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name != %@ || group.curse != %@", groupProfile, groupCurse)
        
        do {
            let result = try self.context.fetch(fetchRequest)
            for res in result {
                self.context.delete(res)
            }
            try self.context.save()
            print("Groups deleted!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func selectGroup(profile groupProfile: String, curse groupCurse: String, groupList groups: [Group]) {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name == %@ AND group.curse == %@", argumentArray: [groupProfile, groupCurse])
        do {
            let result = try self.context.fetch(fetchRequest)
            if result.count == 0 {
                let groupSchedule = GroupSchedule(context: self.context)
                groupSchedule.group = groups.filter {$0.name == groupProfile && $0.curse == groupCurse}.first!
                groupSchedule.timetable = NSOrderedSet(array: [Day]())
                groupSchedule.lastUpdate = nil
                try self.context.save()
                print("New group create!")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
