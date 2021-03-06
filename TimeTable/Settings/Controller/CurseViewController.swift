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
    
    var firstLaunch: Bool?
    var groups: [Group] = []
    var context: NSManagedObjectContext!
    private lazy var groupCurses = GetGroupCurseResponse(groups: groups, groupProfile: groupProfile).groupCurses
    private lazy var groupProfile = UserDefaults.standard.string(forKey: "groupProfile")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let coreDataStorage = CoreDataStorage()
        coreDataStorage.selectGroup(profile: groupProfile, curse: groupCurse, groupList: groups, in: context)
        
        if firstLaunch == true {
            performSegue(withIdentifier: "backToMainSegue", sender: nil)
        }
        performSegue(withIdentifier: "backToSettingsSegue", sender: nil)
    }
}
