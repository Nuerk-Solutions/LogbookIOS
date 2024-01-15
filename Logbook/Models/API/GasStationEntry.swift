//
//  GasStation.swift
//  Logbook
//
//  Created by Thomas on 18.06.22.
//

import Foundation

struct GasStationWelcome: Codable {
    let data: GasStationDataClass
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case success = "Success"
    }
}

struct GasStationDataClass: Codable {
    let totalCount: Int
    let tankstellen: [GasStationEntry]

    enum CodingKeys: String, CodingKey {
        case totalCount = "TotalCount"
        case tankstellen = "Tankstellen"
    }
}

extension GasStationWelcome {

    static var previewData: GasStationWelcome {
        let previewDataURL = Bundle.main.url(forResource: "gasstations", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.readableDeShort)

        let apiResponse = try! jsonDecoder.decode(GasStationWelcome.self, from: data)
        return apiResponse
    }
}

struct GasStationEntry: Codable {
    let poiID: Int
    let name: String
    let tankstellenDescription: String
    let x: Int
    let y: Int
    let lat: Double
    let lon: Double
    let distance: Double
    let strasse: String
    let plz: String
    let ort: String
    let sorte: FuelTyp
    let preis: Double
    let provider: String
    let datum: Date
    let datumSort: String
    let timeSort: String
    let sycAngebote: [SycAngebote]

    enum CodingKeys: String, CodingKey {
        case poiID = "PoiId"
        case name = "Name"
        case tankstellenDescription = "Description"
        case x = "x"
        case y = "y"
        case lat = "Lat"
        case lon = "Lon"
        case distance = "Distance"
        case strasse = "Strasse"
        case plz = "Plz"
        case ort = "Ort"
        case sorte = "Sorte"
        case preis = "Preis"
        case provider = "Provider"
        case datum = "Datum"
        case datumSort = "DatumSort"
        case timeSort = "TimeSort"
        case sycAngebote = "SycAngebote"
    }

}

enum FuelTyp: String, Codable, CodingKey, Identifiable, CaseIterable {
    case SUPER_E10 = "Super_E10" // Only for request
    case SUPER = "Super" // Only for request
    case SUPER_95_E5 = "Super 95 E5"
    case SUPER_95_E10 = "Super 95 E10"
    case SUPER_PLUS_98_E5 = "Super Plus 98 E5"
    case DIESEL = "Diesel"
    
    var id: String { UUID().uuidString }
    
    
    static var allNonApiCases: [FuelTyp] {
        return [.DIESEL, .SUPER_95_E5, .SUPER_95_E10, .SUPER_PLUS_98_E5]
    }
}

struct SycAngebote: Codable {
    let angebotID: Int
    let partnername: String
    let angebotsname: String
    let kategorieID: Int
    let geschaeftsbereichID: Int
    let kurztextVorteil: String
    let teasertext: String
    let istLoginErforderlich: Bool

    enum CodingKeys: String, CodingKey {
        case angebotID = "AngebotId"
        case partnername = "Partnername"
        case angebotsname = "Angebotsname"
        case kategorieID = "KategorieId"
        case geschaeftsbereichID = "GeschaeftsbereichId"
        case kurztextVorteil = "KurztextVorteil"
        case teasertext = "Teasertext"
        case istLoginErforderlich = "IstLoginErforderlich"
    }
}






//struct GasStations {
//    var stations: [GasStationEntry]
//}
//
//extension GasStations: Codable {}
//extension GasStations {
//
//    static var previewData: GasStations {
//        let previewDataURL = Bundle.main.url(forResource: "gasstations", withExtension: "json")!
//        let data = try! Data(contentsOf: previewDataURL)
//        let jsonDecoder = JSONDecoder()
//        jsonDecoder.dateDecodingStrategy = .iso8601
//
//        let apiResponse = try! jsonDecoder.decode(GasStations.self, from: data)
//        return apiResponse
//    }
//}
//
//struct GasStationEntry {
//    var id: String
//    var name: String
//    var brand: String
//    var street: String
//    var place: String
//    var lat: Double
//    var lng: Double
//    var dist: Double
//    var price: Double?
//    var isOpen: Bool
//    var houseNumber: String
//    var postCode: Int
//    //    var bearing: Double?
//}
//
//extension GasStationEntry: Codable {}
//extension GasStationEntry: Equatable {}
//extension GasStationEntry: Identifiable {}
