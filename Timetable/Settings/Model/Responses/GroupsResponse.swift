//
//  GroupResponse.swift
//  TimeTable
//
//  Created by ar_ko on 05/03/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import CoreData


struct GetGroupsResponse {
    var groups: [Group] = []
    
    
    init(context: NSManagedObjectContext) {
        let pathToFile = Bundle.main.path(forResource: "Groups", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: pathToFile!)!
         
        for dictionary in dataArray {
            let group = Group(context: context)
            
            let groupDictionary = dictionary as! NSDictionary
            group.name = groupDictionary["name"] as! String
            group.curse = groupDictionary["curse"] as! String
            group.sheetId = groupDictionary["sheetId"] as! String
            group.spreadsheetId = groupDictionary["spreadsheetId"] as! String
            group.startColumn = groupDictionary["startColumn"] as! String
            group.startRow = groupDictionary["startRow"] as! Int16
            group.endColumn = groupDictionary["endColumn"] as! String
            group.endRow = groupDictionary["endRow"] as! Int16
            group.groupInfoStartColumn = groupDictionary["groupInfoStartColumn"] as! String
            group.groupInfoStartRow = groupDictionary["groupInfoStartRow"] as! Int16
            group.groupInfoEndColumn = groupDictionary["groupInfoEndColumn"] as! String
            group.groupInfoEndRow = groupDictionary["groupInfoEndRow"] as! Int16
            
            groups.append(group)
        }
    }
}
