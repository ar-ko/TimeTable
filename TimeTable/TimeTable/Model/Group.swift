//
//  Group.swift
//  TimeTable
//
//  Created by ar_ko on 03/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation


struct Group {
    let name: String
    let curse: String
    let semestrDate: String
    let practiceDate: String?
    
    let spreadsheetId: String
    let sheetId: String
    let fields: String
    let urlString: String
    
    let startColumn: String
    let startRow: Int
    let endColumn: String
    let endRow: String
    
    init(name: String, curse: String, semestrDate: String, practiceDate: String?, sheetId: String, startColumn: String, startRow: Int, endColumn: String, endRow: String) {
        self.name = name
        self.curse = curse
        self.semestrDate = semestrDate
        self.practiceDate = practiceDate
        
        self.spreadsheetId = "1CrVXpFRuvS4iq8nvGpd27-CeUcnzsRmbNc9nh2CWcWw"
        self.sheetId = sheetId
        self.fields = "sheets(merges,data(rowData(values(formattedValue,note,effectiveFormat(backgroundColor,textFormat(foregroundColor))))))"
        let range = startColumn + String(startRow) + ":" + endColumn + String(endRow)
        self.urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)?ranges=\(sheetId)!\(range)&fields=\(fields)&key=\(ApiKey)"
        
        self.startColumn = startColumn
        self.startRow = startRow
        self.endColumn = endColumn
        self.endRow = endRow
    }
}
