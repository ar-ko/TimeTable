//
//  GroupCourseResponse.swift
//  TimeTable
//
//  Created by ar_ko on 14/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

struct GetGroupCourseResponse {
    var groupCourses: [String]
    
    
    init(groups: [Group], groupProfile: String) {
        var groupCourses: [String] = []
        for group in groups {
            if group.name == groupProfile {
                groupCourses.append(group.course)
            }
        }
        groupCourses.sort()
        
        self.groupCourses = groupCourses
    }
}
