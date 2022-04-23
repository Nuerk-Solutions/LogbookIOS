//
//  LogbookListViewModel.swift
//  Logbook
//
//  Created by Thomas on 05.01.22.
//

import Foundation
import SwiftUI
import Alamofire
import Combine
class ListViewModel: ObservableObject {
    
    @Published private var originalLogbooks = [LogbookModel]()
    @Published var logbooks = [LogbookModel]()
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var searchTerm: String = ""
    
    @Published var logbookListFull = false
    var currentPage = 0
    let perPage = 25
    private var cancellable: AnyCancellable? = nil
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    
    init() {
        session = Session(interceptor: interceptor)
        withAnimation {
            Publishers.CombineLatest($originalLogbooks, $searchTerm)
                .map { logbooks, searchTerm in
                    logbooks.filter { logbook in
                        searchTerm.isEmpty ? true : (logbook.driveReason.contains(searchTerm) || logbook.driver.id.contains(searchTerm))
                    }
                }
                .debounce(for: .seconds(1), scheduler: RunLoop.main)
                .assign(to: &$logbooks)
            
        }
    }
    
    
    
    @MainActor
    func fetchLogbooks() async {
        showAlert = false
        errorMessage = nil
        if !Reachability.isConnectedToNetwork() {
            self.errorMessage = "Bitte stelle sicher das du eine Verbindung zum Internet hast!"
            self.showAlert = true
            self.isLoading = false
            return
        }
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        let url = "https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/find/all?sort=-date&page=\(currentPage)&limit=\(perPage)"
        print(url)
        self.cancellable = session.request(url, method: .get)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        self.isLoading = false
                        print("error fetch all", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Fetch All:", data)
                    withAnimation {
                        self.isLoading = false
                    }
                    break
                }
            }
            .publishDecodable(type: [LogbookModel].self, decoder: decoder)
            .tryMap {$0.value}
            .receive(on: RunLoop.main)
            .catch { _
                in
                
                    withAnimation {
                Just(self.originalLogbooks)
                    }
                
            }
            .sink { [weak self] in
//                    let logbooksString: [String] = (self?.originalLogbooks.map { $0._id })!
                    //                if logbooksString.contains(($0?.last!._id)!) {
                    //                    self?.logbookListFull = true
                    //                    self?.isLoading = false
                    //                    return
                    //                }
                    self?.currentPage += 1
                    //                var asd: [LogbookModel] = $0!
                    //                asd.removeAll(where: { model in
                    //                    return logbooksString.contains(model._id)
                    //                })
                    self?.originalLogbooks.append(contentsOf: $0! )
                    self?.isLoading = false
                    // If count of data receieved is less than perPage value then it is last page
                    // TODO: Impl in backend
                    
                    
                    if $0!.count < self!.perPage {
                        self?.logbookListFull = true
                    }
                
            }
    }
    
    @MainActor
    func fetchAllLogbooks() async {
        showAlert = false
        errorMessage = nil
        withAnimation {
            isLoading.toggle()
        }
        if !Reachability.isConnectedToNetwork() {
            self.errorMessage = "Bitte stelle sicher das du eine Verbindung zum Internet hast!"
            self.showAlert = true
            self.isLoading = false
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        //            logbooks = try await apiService.getJSON(dateDecodingStrategy: .formatted(dateFormatter))
        session.request("https://europe-west1-logbookbackend.cloudfunctions.net/api/logbook/find/all?sort=-date", method: .get)
            .validate(statusCode: 200..<201)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case.failure(let error):
                    switch response.response?.statusCode {
                    default:
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        self.isLoading = false
                        print("error fetch all", error)
                        break
                    }
                    print(error)
                case.success(let data):
                    print("Sucess Fetch All:", data)
                    withAnimation {
                        self.isLoading.toggle()
                    }
                    break
                }
            }
            .responseDecodable(of: [LogbookModel].self, decoder: decoder) { (response) in
                withAnimation {
                    self.originalLogbooks = response.value ?? []
                }
            }
    }
}
