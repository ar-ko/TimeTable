//
//  Group+CoreDataProperties.swift
//  TimeTable
//
//  Created by ar_ko on 05/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//
//

import CoreData


extension Group {

    @NSManaged public var name: String
    @NSManaged public var curse: String
    
    @NSManaged public var practiceDate: Date?
    @NSManaged public var semestrDate: Date?
    
    @NSManaged public var startColumn: String
    @NSManaged public var startRow: Int16
    @NSManaged public var endColumn: String
    @NSManaged public var endRow: Int16
    
    @NSManaged public var sheetId: String
    @NSManaged public var spreadsheetId: String
    var urlString: String {
        get {
            let fields = "sheets(merges,data(rowData(values(formattedValue,note,effectiveFormat(backgroundColor,textFormat(foregroundColor))))))"
            let range = startColumn + String(startRow) + ":" + endColumn + String(endRow)
            
            return "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)?ranges=\(sheetId)!\(range)&fields=\(fields)&key=\(ApiKey)"
        }
    }
    
    @NSManaged public var groupInfoStartColumn: String
    @NSManaged public var groupInfoStartRow: Int16
    @NSManaged public var groupInfoEndColumn: String
    @NSManaged public var groupInfoEndRow: Int16
    
    @NSManaged public var numberOfPersons: Int16
    
    @NSManaged public var groupSchedule: GroupSchedule?

    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }
            
}
