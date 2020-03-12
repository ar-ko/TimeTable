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
    
    var context: NSManagedObjectContext?
    private var groups: [Group] = []
    
    @IBOutlet weak var groupProfileLabel: UILabel!
    @IBOutlet weak var groupCurseLabel: UILabel!
    @IBOutlet weak var clearCacheButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        let groupProfile = UserDefaults.standard.string(forKey: "groupProfile")
        let groupCurse = UserDefaults.standard.string(forKey: "groupCurse")
        
        groupProfileLabel.text = groupProfile
        groupCurseLabel.text = groupCurse
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
        
        clearCacheButton.setTitleColor(#colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1), for: .normal)
        clearCacheButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbc = self.tabBarController as? CustomTabBarController {
            context = tbc.context
        }
        
        groups = GetGroupsResponse(context: context!).groups
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showProfileSegue",
            let destination = segue.destination as? ProfileViewController {
            
            destination.context = context
            
        }
        if segue.identifier == "changeCurseSegue",
            let destination = segue.destination as? CurseViewController {

            destination.groups = groups
            destination.context = context
        }
        
    }
    
    @IBAction func clearCacheButtonPressed(_ sender: Any) {
        let groupProfile = UserDefaults.standard.string(forKey: "groupProfile")
        let groupCurse = UserDefaults.standard.string(forKey: "groupCurse")
        
        let fetchRequest: NSFetchRequest<GroupSchedule> = GroupSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "group.name != %@ AND group.curse != %@", argumentArray: [groupProfile!, groupCurse!])
        do {
            let result = try context!.fetch(fetchRequest)
            for res in result {
                context!.delete(res)
            }
            try context!.save()
            print("Cache clear!")
        } catch {
            print(error)
        }
        clearCacheButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        clearCacheButton.isEnabled = false
    }
    
    @IBAction func cancelAction(_ seque: UIStoryboardSegue) {
    }
}
