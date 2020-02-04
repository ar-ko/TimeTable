//
//  TimeTableNetworkService.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation


class TimeTableNetworkService {
    
    private init() {}
    
    
    static func getTimeTable(group: Group, completion: @escaping(GetTimeTableResponse?) -> ()) {
        guard let url = URL(string: group.urlString) else { return }
        
        NetworkService.shared.getData(url: url) { (json) in
            guard let json = json as? TimeTableJSON else { return }
            let response = GetTimeTableResponse(of: json, for: group)
            completion(response)
        }
    }
    
}
