//
//  CurseViewController.swift
//  TimeTable
//
//  Created by ar_ko on 05/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


class CurseViewController: UITableViewController {
    
    var firstLaunch: Bool?
    var groups: [Group] = []
    var core: CoreDataManager!
    private lazy var groupCurses = GetGroupCurseResponse(groups: groups, groupProfile: groupProfile).groupCurses
    private var groupProfile: String {
        return UserDefaults.standard.string(forKey: "groupProfile") ?? ""
    }
    
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
        
        core.selectGroup(profile: groupProfile, curse: groupCurse, groupList: groups)
        
        if firstLaunch == true {
            performSegue(withIdentifier: "backToMainSegue", sender: nil)
        }
        performSegue(withIdentifier: "backToSettingsSegue", sender: nil)
    }
}
