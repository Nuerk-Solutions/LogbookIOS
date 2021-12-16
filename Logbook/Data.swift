//
//  Data.swift
//  Logbook
//
//  Created by Thomas on 02.12.21.
//

import SwiftUI
import Combine

class Api {
    func getLogbookEntries(completion: @escaping ([Logbook]?, Error?) -> ()) {
        guard let url = URL(string: "https://api.nuerk-solutions.de/logbook") else { fatalError("Missing URL")} // guard adds a condition. because swift is typesafe you need to be sure to have the right type; if the URL is empty or nil then return the func at that point
        
        let urlRequest = URLRequest(url: url)
        
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
             if let error = error {
                 print("Request error: ", error)
                 return
             }

             guard let response = response as? HTTPURLResponse else { return }

             if response.statusCode == 200 {
                 guard let data = data else { return }
                 
                 let decoder = JSONDecoder()
                 decoder.dateDecodingStrategyFormatters = [DateFormatter.standardT]
                 decoder.keyDecodingStrategy = .convertFromSnakeCase
                 
                 DispatchQueue.main.async {
                     do {
                         let logbookEntries = try decoder.decode([Logbook].self, from: data)
                         completion(logbookEntries, nil)
                     } catch let error {
                         print("Error decoding: ", error)
                         completion(nil, nil)
                     }
                 }
             } else {
                 completion(nil, HttpError.statusNot200)
             }
         }

         dataTask.resume()
    }
}
