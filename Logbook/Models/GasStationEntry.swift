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

struct GasStationRequestParameters {
    
    var lat: Double
    var lng: Double
    var fuelTyp: String
    var radius: Int
    var pageSize: Int = 10
    var pageNumber: Int = 1
    var sortTyp: SortTyp
    var sortDirection: String
    
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


enum FuelTyp: String, Codable, Identifiable, CaseIterable {
    case SUPER_95_E5 = "Super"
    case SUPER_95_E10
    case SUPER_PLUS_98_E5
    case DIESEL = "Diesel"
    case SP_VP_AU
    
    var id: String { UUID().uuidString }
    
    static var apiCases: [FuelTyp] {
        return [.DIESEL, .SUPER_95_E5]
    }
    
    var apiName: String {
        switch self {
        case .DIESEL:
            return "Diesel"
        default:
            return "Super"
            
        }
    }
    
    var name: String {
        switch self {
        case .DIESEL:
            return "Diesel"
        case .SUPER_95_E5:
            return "Super 95 E5"
        case .SUPER_95_E10:
            return "Super 95 E10"
        case .SUPER_PLUS_98_E5:
            return "Super Plus 98 E5"
        case .SP_VP_AU:
            return "SuperPremium (VPower,...)"
        }
    }
}

extension FuelTyp {
    
}

enum SortTyp: String, CaseIterable {
    case Preis
    case Distance
    case Name
    
    var description: String {
        switch self {
        case .Preis: return "Preis"
        case .Distance: return "Entfernung"
        case .Name: return "Name"
        }
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
