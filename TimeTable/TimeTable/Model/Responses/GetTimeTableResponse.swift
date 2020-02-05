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
        let startColumnIndex = letterToIndex(letter: group.startColumn)
        let startRowIndex = group.startRow - 1
        
        let daysSeparator = getDaysSeparator(json: json, rangeIndexes: (startColumnIndex: startColumnIndex, startRowIndex: startRowIndex))
        
        let timeTable = JSONParser(json: json, daysSeparator: daysSeparator, rangeIndexes: (startColumnIndex: startColumnIndex, startRowIndex: startRowIndex))
        
        self.timeTable =  timeTable
    }
    
}
