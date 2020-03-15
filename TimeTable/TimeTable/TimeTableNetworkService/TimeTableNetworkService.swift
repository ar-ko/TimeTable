//
//  TimeTableNetworkService.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import CoreData


class TimeTableNetworkService {
    
    private init() {}
    
    
    static func getTimeTable(group: Group, context: NSManagedObjectContext, completion: @escaping(GetTimeTableResponse?) -> ()) {
        guard let url = URL(string: group.urlString) else { return }
        
        NetworkService.shared.getData(url: url) { (json) in
            if let json = json as? TimeTableJSON {
                let response = GetTimeTableResponse(of: json, for: group, context: context)
                
                completion(response)
            }
            else {
                completion(nil)
            }
        }
    }
}
