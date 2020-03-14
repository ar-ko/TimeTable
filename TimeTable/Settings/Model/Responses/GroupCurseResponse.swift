//
//  GroupCurseResponse.swift
//  TimeTable
//
//  Created by ar_ko on 14/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation


struct GetGroupCurseResponse {
    var groupCurses: [String]
    
    
    init(groups: [Group], groupProfile: String) {
        var groupCurses: [String] = []
        for group in groups {
            if group.name == groupProfile {
                groupCurses.append(group.curse)
            }
        }
        groupCurses.sort()
        
        self.groupCurses = groupCurses
    }
}
