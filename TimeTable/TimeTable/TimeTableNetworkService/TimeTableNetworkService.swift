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
    
    
    static func getTimeTable(completion: @escaping(GetTimeTableResponse?) -> ()) {
        guard let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/1CrVXpFRuvS4iq8nvGpd27-CeUcnzsRmbNc9nh2CWcWw?ranges=%D0%BF%D1%80%D0%BE%D1%84%D1%8B!B11:E175&fields=sheets(merges,data(rowData(values(formattedValue,note,effectiveFormat(backgroundColor,textFormat(foregroundColor))))))&key=AIzaSyBg-JW7nhA-be4jnfy-UKFVXcfefkjofVw") else { return }
        
        NetworkService.shared.getData(url: url) { (json) in
            guard let json = json as? TimeTableJSON else { return }
            let response = GetTimeTableResponse(json: json)
            completion(response)
        }
    }
    
}
