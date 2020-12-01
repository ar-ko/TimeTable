//
//  SettingsViewModel.swift
//  TimeTable
//
//  Created by ar_ko on 01.12.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation

class SettingsViewModel {
    let coreDataManager: CoreDataManager
    var groupProfile: String {
        return UserDefaults.standard.string(forKey: "groupProfile") ?? ""
    }
    var groupCourse: String {
        return UserDefaults.standard.string(forKey: "groupCourse") ?? ""
    }
    
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    
    func clearCoreDataCache() {
        coreDataManager.clearCoreDataExcept(profile: groupProfile, course: groupCourse)
    }
}
