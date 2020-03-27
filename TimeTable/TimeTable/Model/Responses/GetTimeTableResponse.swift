//
//  GetTimeTableResponse.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import CoreData


struct GetTimeTableResponse {
    var timeTable: [Day]!
    
    
    init(of json: TimeTableJSON, for group: Group, context: NSManagedObjectContext) {
        let startColumnIndex = letterToIndex(letter: group.startColumn)
        let startRowIndex = Int(group.startRow - 1)
        
        let daysSeparator = getDaysSeparator(json: json, rangeIndexes: (startColumnIndex: startColumnIndex, startRowIndex: startRowIndex))
        
        let timeTable = JSONParser(json: json, daysSeparator: daysSeparator, context: context, rangeIndexes: (startColumnIndex: startColumnIndex, startRowIndex: startRowIndex))
        self.timeTable = timeTable
    }
}
