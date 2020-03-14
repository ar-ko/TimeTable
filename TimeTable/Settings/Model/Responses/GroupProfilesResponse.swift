//
//  GroupProfiles.swift
//  TimeTable
//
//  Created by ar_ko on 14/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation


struct GetGroupProfilesResponse{
    let groupProfiles: [String]
    
    
    init(groups: [Group]) {
        var groupProfiles: [String] = []
        for group in groups {
            if !groupProfiles.contains(group.name) {
                groupProfiles.append(group.name)
            }
        }
        groupProfiles.sort()
        
        self.groupProfiles = groupProfiles
    }
}
