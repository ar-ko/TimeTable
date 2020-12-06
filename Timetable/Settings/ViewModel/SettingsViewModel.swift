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
    var coordinator: SettingsCoordinator?
    
    var groupProfile: String {
        return UserDefaults.standard.string(forKey: "groupProfile") ?? ""
    }
    var groupCourse: String {
        return UserDefaults.standard.string(forKey: "groupCourse") ?? ""
    }
    
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    
    func tappedButton(withIndexPath indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            openProfile()
        case (1, 0): clearCoreDataCache()
        default:
            print("nope")
        }
    }
    
    private func clearCoreDataCache() {
        coreDataManager.clearCoreDataExcept(profile: groupProfile, course: groupCourse)
    }
    
    private func openProfile() {
        coordinator?.openProfile()
    }
}
