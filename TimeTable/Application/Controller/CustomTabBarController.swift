//
//  CustomTabBarController.swift
//  TimeTable
//
//  Created by ar_ko on 01/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit
import CoreData


class CustomTabBarController: UITabBarController {
    
    var groupScheldue: GroupSchedule?
    var context: NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
