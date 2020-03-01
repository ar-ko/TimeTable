//
//  ViewController.swift
//  TimeTable
//
//  Created by ar_ko on 29/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit
import CoreData


class GroupSettingsViewController: UIViewController {
    var context: NSManagedObjectContext?
    var groupScheldue: GroupSchedule?
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupCurseLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let tbc = self.tabBarController as? CustomTabBarController {
            context = tbc.context
            groupScheldue = tbc.groupScheldue
        }
        
        groupNameLabel.text = groupScheldue?.group.name
        groupCurseLabel.text = groupScheldue?.group.curse
    }
}
