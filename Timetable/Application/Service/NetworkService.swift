//
//  NetworkService.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import Foundation

class NetworkService {
    private init() {}
    static let shared = NetworkService()
    
    public func getData(url: URL, completion: @escaping (Any?) -> ()) {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            do {
                
                guard let data = data else { throw NetworkError.noInternetConnection }
                
                let timetableJSON = try JSONDecoder().decode(GoogleSheetsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(timetableJSON)
                }
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}
