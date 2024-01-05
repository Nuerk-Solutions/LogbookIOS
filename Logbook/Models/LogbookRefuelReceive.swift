//
//  LogookEntryRefueled.swift
//  Logbook
//
//  Created by Thomas Nürk on 03.01.24.
//

import Foundation


struct LogbookRefuelReceive: Codable, Identifiable, Equatable {
    
    let id = UUID()
    
    let vehicle: VehicleEnum
    var refuels: [RefuelsRecive]
}

struct RefuelsRecive: Codable, Equatable, Identifiable {
    
    let id = UUID()
    
    let date: Date
    let refuel: RefuelRecive
    var animated: Bool? = false
    var sumAverage: Double?
}

struct RefuelRecive: Codable, Equatable {
    
    let liters: Double
    let price: Double
    let distanceDifference: Double
    let consumption: Double
    let isSpecial: Bool
    let previousRecordID: String?
    
    enum CodingKeys: String, CodingKey {
        case liters, price, distanceDifference, consumption, isSpecial
        case previousRecordID = "previousRecordId"
    }
}

extension LogbookRefuelReceive {
    
    static var previewData: [LogbookRefuelReceive] {
        let previewDataURL = Bundle.main.url(forResource: "refuellogbooks", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.iso8601Full)
        var apiResponse: [LogbookRefuelReceive] = []
        do {
        apiResponse = try jsonDecoder.decode([LogbookRefuelReceive].self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("could not find key \(key) in JSON: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("could not find type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            print("data found to be corrupted in JSON: \(context.debugDescription)")
        }
        catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
        
        return apiResponse
    }
}
