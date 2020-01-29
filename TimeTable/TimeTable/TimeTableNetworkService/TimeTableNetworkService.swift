//
//  TimeTableNetworkService.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation


class TimeTableNetworkSwrvice {
    
    private init() {}
    
    static func getTimeTable(completion: @escaping(GetTimeTableResponse) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        NetworkService.shared.getData(url: url) { (json) in
            
        }
        
    }
    
    
}
