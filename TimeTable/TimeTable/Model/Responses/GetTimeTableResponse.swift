//
//  GetTimeTableResponse.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation


struct GetTimeTableResponse {
    let timeTable: [[Lesson]]
    
    init(json: TimeTableJSON) {
        
        print(json)

        self.timeTable = [[Lesson]]()
    }
}
