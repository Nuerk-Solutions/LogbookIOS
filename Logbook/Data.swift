//
//  Data.swift
//  Logbook
//
//  Created by Thomas on 02.12.21.
//

import SwiftUI
import Combine

struct Logbook: Codable, Identifiable {
    let id = UUID()
    var driver: DriverEnum
    var vehicle: Vehicle
    var date: Date
    var driveReason: String
    var additionalInformation: AdditionalInformation?
}

struct Vehicle: Codable, Identifiable, Hashable {
    let id = UUID()
    
    var typ: VehicleEnum
    var currentMileAge: Int
    var newMileAge: Int
    //    var distance: Int
    //    var cost: Float
}

struct AdditionalInformation: Codable, Identifiable {
    let id = UUID()
    
    var informationTyp: AdditionalInformationEnum?
    var inforamtion: String?
    var distanceSinceLastInformation: Int?
}

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
