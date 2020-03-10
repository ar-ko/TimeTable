//
//  CurseViewController.swift
//  TimeTable
//
//  Created by ar_ko on 05/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit
import CoreData


class CurseViewController: UITableViewController {

    var groups: [Group] = []
    var context: NSManagedObjectContext?
    private var groupCurses: [String] = []
    private var groupProfile:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupProfile = UserDefaults.standard.string(forKey: "groupProfile")
        
         for group in groups {
             if group.name == groupProfile {
                 groupCurses.append(group.curse)
             }
         }
         groupCurses.sort()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupCurses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurseCell", for: indexPath)
        cell.textLabel?.text = groupCurses[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupCurse = groupCurses[indexPath.row]
        
        UserDefaults.standard.set(groupCurse, forKey: "groupCurse")
        
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name == %@ AND group.curse == %@", argumentArray: [groupProfile!, groupCurse])
        do {
            let result = try self.context!.fetch(fetchRequest)
            if result.count == 0 {
                let groupSchedule = GroupSchedule(context: context!)
                groupSchedule.group = groups.filter {$0.name == groupProfile && $0.curse == groupCurse}.first!
                groupSchedule.timeTable = NSOrderedSet(array: [Day]())
                groupSchedule.lastUpdate = nil
                
                try context!.save()
                print("New group create!")
            }
        } catch {
            print(error)
        }
    }
}
