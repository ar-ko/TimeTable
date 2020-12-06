//
//  CourseViewModel.swift
//  TimeTable
//
//  Created by ar_ko on 13.11.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation

class CourseViewModel {
    private var groups: [Group]
    private let coreDataManager: CoreDataManager
    var groupCourses: [String] {
        return GetGroupCourseResponse(groups: groups, groupProfile: self.groupProfile).groupCourses
    }
    private var groupProfile: String {
        return UserDefaults.standard.string(forKey: "groupProfile") ?? ""
    }
    
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.groups = GetGroupsResponse(context: coreDataManager.context).groups
    }
    
    
    func selectGroup(index: Int) {
        guard index <= groupCourses.count else { return }
        UserDefaults.standard.set(groupCourses[index], forKey: "groupCourse")
        coreDataManager.selectGroup(profile: groupProfile, course: groupCourses[index], groupList: groups)
    }
}
