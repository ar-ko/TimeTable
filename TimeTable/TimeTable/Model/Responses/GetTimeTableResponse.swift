//
//  GetTimeTableResponse.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation


struct GetTimeTableResponse {
    var timeTable: [[Lesson]]!
    
    init(of json: TimeTableJSON, for group: Group) {
        
        let timeTable = JSONParser(of: json, for: group)
        
        self.timeTable =  timeTable
    }
    
}
