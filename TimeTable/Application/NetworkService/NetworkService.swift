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
    
    
    public func getData(url: URL, completion: @escaping (Data) -> ()) {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
        guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
        }
        }.resume()
    }
    
}
