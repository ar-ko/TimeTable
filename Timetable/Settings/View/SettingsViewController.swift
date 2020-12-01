//
//  SettingsViewController.swift
//  TimeTable
//
//  Created by ar_ko on 03/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    var settingsViewModel: SettingsViewModel?
    
    
    @IBOutlet weak var groupProfileLabel: UILabel!
    @IBOutlet weak var groupCourseLabel: UILabel!
    @IBOutlet weak var clearCacheButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tbc = self.tabBarController as? CustomTabBarController,
              let coreDataManager = tbc.core else { return }
        self.settingsViewModel = SettingsViewModel(coreDataManager: coreDataManager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let settingsViewModel = settingsViewModel else { return }
        
        groupProfileLabel.text = settingsViewModel.groupProfile
        groupCourseLabel.text = settingsViewModel.groupCourse
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
        
        clearCacheButton.setTitleColor(#colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1), for: .normal)
        clearCacheButton.isEnabled = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsViewModel = settingsViewModel else { return }
        
        if segue.identifier == "showProfileSegue",
           let destination = segue.destination as? ProfileViewController {
            
            destination.coreDataManager = settingsViewModel.coreDataManager
        } else if segue.identifier == "changeCourseSegue",
                  let destination = segue.destination as? CourseViewController {
            
            destination.coreDataManager = settingsViewModel.coreDataManager
        }
    }
    
    @IBAction func clearCacheButtonPressed(_ sender: Any) {
        guard let settingsViewModel = settingsViewModel else { return }
        
        settingsViewModel.clearCoreDataCache()
        
        clearCacheButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        clearCacheButton.isEnabled = false
    }
    
    @IBAction func cancelAction(_ seque: UIStoryboardSegue) {
    }
}
