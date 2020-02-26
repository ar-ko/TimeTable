//
//  Group+CoreDataProperties.swift
//  TimeTable
//
//  Created by ar_ko on 25/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var name: String
    @NSManaged public var curse: String
    
    @NSManaged public var practiceDate: Date?
    @NSManaged public var semestrDate: Date?
    
    @NSManaged public var sheetId: String
    var urlString: String {
        get {
            let spreadsheetId = "1CrVXpFRuvS4iq8nvGpd27-CeUcnzsRmbNc9nh2CWcWw"
            let fields = "sheets(merges,data(rowData(values(formattedValue,note,effectiveFormat(backgroundColor,textFormat(foregroundColor))))))"
            let range = startColumn + String(startRow) + ":" + endColumn + String(endRow)
            
            return "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)?ranges=\(sheetId)!\(range)&fields=\(fields)&key=\(ApiKey)"
        }
    }
    
    @NSManaged public var endColumn: String
    @NSManaged public var endRow: Int16
    @NSManaged public var startColumn: String
    @NSManaged public var startRow: Int16

    @NSManaged public var groupSchedule: GroupSchedule

}
