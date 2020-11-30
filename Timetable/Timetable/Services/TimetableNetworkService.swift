//
//  TimeTableNetworkService.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import CoreData

class TimetableNetworkService {
    private init() {}
    
    static func getTimetable(group: Group, context: NSManagedObjectContext, completion: @escaping(GoogleSheetsParser?) -> ()) {
        guard let url = URL(string: group.urlString) else { return }
        
        NetworkService.shared.getData(url: url) { (json) in
            if let json = json as? GoogleSheetsResponse {
                let response = GoogleSheetsParser(of: json, for: group, in: context)
                
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
}
