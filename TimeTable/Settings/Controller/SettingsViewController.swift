//
//  SettingsViewController.swift
//  TimeTable
//
//  Created by ar_ko on 03/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController {
    
    var groupSchedule: GroupSchedule?
    var context: NSManagedObjectContext?
    var groups: [Group] = []
    var groupProfile = UserDefaults.standard.string(forKey: "groupProfile")
    var groupCurse = UserDefaults.standard.string(forKey: "groupCurse")
    
    
    @IBOutlet weak var groupProfileLabel: UILabel!
    @IBOutlet weak var groupCurseLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        groupProfile = UserDefaults.standard.string(forKey: "groupProfile")
        groupCurse = UserDefaults.standard.string(forKey: "groupCurse")
        
        groupProfileLabel.text = groupProfile
        groupCurseLabel.text = groupCurse
        
        groupSchedule?.group = groups.filter {$0.name == groupProfile && $0.curse == groupCurse}.first!
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbc = self.tabBarController as? CustomTabBarController {
            groupSchedule = tbc.groupScheldue
            context = tbc.context
        }
        
        groups = GetGroupsResponse(context: context!).groups
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showProfileSegue",
            let destination = segue.destination as? ProfileViewController {
            var groupProfiles: [String] = []
            for group in groups {
                if !groupProfiles.contains(group.name) {
                    groupProfiles.append(group.name)
                }
            }
            groupProfiles.sort()
            destination.groupProfiles = groupProfiles
            destination.context = context!
            destination.groups = groups
        }
        if segue.identifier == "changeCurseSegue",
            let destination = segue.destination as? CurseViewController {
            var groupCurses: [String] = []
            for group in groups {
                if group.name == UserDefaults.standard.string(forKey: "groupProfile") {
                    groupCurses.append(group.curse)
                }
            }
            groupCurses.sort()
            destination.groupCurses = groupCurses
        }
        
    }
    
    @IBAction func cancelAction(_ seque: UIStoryboardSegue) {}
}
