//
//  SettingsViewController.swift
//  TimeTable
//
//  Created by ar_ko on 03/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


class SettingsViewController: UITableViewController {
    
    var coreDataManager: CoreDataManager!
    private var groupProfile: String {
        return UserDefaults.standard.string(forKey: "groupProfile") ?? ""
    }
    private var groupCourse: String {
        return UserDefaults.standard.string(forKey: "groupCourse") ?? ""
    }
    
    @IBOutlet weak var groupProfileLabel: UILabel!
    @IBOutlet weak var groupCourseLabel: UILabel!
    @IBOutlet weak var clearCacheButton: UIButton!
    
    static func instantiate() -> SettingsViewController {
        let storyboadr = UIStoryboard(name: "SettingsStoryboard", bundle: .main)
        let controller = storyboadr.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        return controller
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbc = self.tabBarController as? CustomTabBarController {
            coreDataManager = tbc.core
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        groupProfileLabel.text = groupProfile
        groupCourseLabel.text = groupCourse
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
        
        clearCacheButton.setTitleColor(#colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1), for: .normal)
        clearCacheButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileSegue",
           let destination = segue.destination as? ProfileViewController {
            
            destination.coreDataManager = coreDataManager
        }
        if segue.identifier == "changeCourseSegue",
           groupProfile != "",
           let destination = segue.destination as? CourseViewController {
            
            destination.coreDataManager = coreDataManager
        }
    }
    
    @IBAction func clearCacheButtonPressed(_ sender: Any) {
        coreDataManager.clearCoreDataExcept(profile: groupProfile, course: groupCourse)
        
        clearCacheButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        clearCacheButton.isEnabled = false
    }
    
    @IBAction func cancelAction(_ seque: UIStoryboardSegue) {
    }
}
