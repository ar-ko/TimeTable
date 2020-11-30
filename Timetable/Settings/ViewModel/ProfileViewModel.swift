//
//  ProfileViewModel.swift
//  TimeTable
//
//  Created by ar_ko on 13.11.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation

class ProfileViewModel {
    private let coreDataManager: CoreDataManager
    private var originalProfiles: [String]
    private var filteredProfiles: [String] = []
    private var isFiltering: Bool = false
    
    var profiles: [String] {
        return isFiltering ? filteredProfiles : originalProfiles
    }
    
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        let groups = GetGroupsResponse(context: coreDataManager.context).groups
        self.originalProfiles = GetGroupProfilesResponse(groups: groups).groupProfiles
    }
    
    
    func filterProfilesBySearchText(_ searchText: String) {
        isFiltering = searchText == "" ? false : true
        
        filteredProfiles = originalProfiles.filter({ (groupProfile) -> Bool in
            return groupProfile.lowercased().contains(searchText.lowercased())
        })
    }
    
    func selectProfile(index: Int) {
        UserDefaults.standard.set(profiles[index], forKey: "groupProfile")
    }
    
}
