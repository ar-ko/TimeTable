//
//  CoreDataStorage.swift
//  TimeTable
//
//  Created by ar_ko on 13/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation
import CoreData


struct CoreDataStorage {
    
    
    func clearCoreDataExcept(groupProfile: String, groupCurse: String, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name != %@ AND group.curse != %@", argumentArray: [groupProfile, groupCurse])
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
}
