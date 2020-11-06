//
//  SettingsViewController.swift
//  TimeTable
//
//  Created by ar_ko on 03/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


class SettingsViewController: UITableViewController {
    
    var core: CoreDataManager!
    private var groups: [Group] = []
    private var groupProfile: String {
        return UserDefaults.standard.string(forKey: "groupProfile") ?? ""
    }
    private var groupCurse: String {
        return UserDefaults.standard.string(forKey: "groupCurse") ?? ""
    }
    
    @IBOutlet weak var groupProfileLabel: UILabel!
    @IBOutlet weak var groupCurseLabel: UILabel!
    @IBOutlet weak var clearCacheButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbc = self.tabBarController as? CustomTabBarController {
            core = tbc.core
        }
        
        groups = GetGroupsResponse(context: core.context).groups
    }
    
    override func viewWillAppear(_ animated: Bool) {
        groupProfileLabel.text = groupProfile
        groupCurseLabel.text = groupCurse
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
        
        clearCacheButton.setTitleColor(#colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1), for: .normal)
        clearCacheButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileSegue",
           let destination = segue.destination as? ProfileViewController {
            
            destination.groups = groups
            destination.core = core
        }
        if segue.identifier == "changeCurseSegue",
           groupProfile != "",
           let destination = segue.destination as? CurseViewController {
            
            destination.groups = groups
            destination.core = core
        }
    }
    
    @IBAction func clearCacheButtonPressed(_ sender: Any) {
        CoreDataManager().clearCoreDataExcept(profile: groupProfile, curse: groupCurse)
        
        clearCacheButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        clearCacheButton.isEnabled = false
    }
    
    @IBAction func cancelAction(_ seque: UIStoryboardSegue) {
    }
}
