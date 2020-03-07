//
//  ProfileViewController.swift
//  TimeTable
//
//  Created by ar_ko on 05/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit
import CoreData


class ProfileViewController: UITableViewController {
    
    var groupProfiles: [String] = []
    var groups: [Group] = []
    var context: NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCurseSegue",
            let destination = segue.destination as? CurseViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            let groupProfile = groupProfiles[indexPath.row]
            UserDefaults.standard.set(groupProfile, forKey: "groupProfile")
            
            var groupCurses: [String] = []
            for group in groups {
                if group.name == groupProfile {
                    groupCurses.append(group.curse)
                }
            }
            groupCurses.sort()
            destination.groupCurses = groupCurses
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        cell.textLabel?.text = groupProfiles[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupProfiles.count
    }
}
