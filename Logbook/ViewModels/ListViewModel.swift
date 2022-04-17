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
    
    var logbookListFull = false
    var currentPage = 0
    let perPage = 10
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
            //            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
                .assign(to: &$logbooks)
            
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    
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
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
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
                        self.isLoading.toggle()
                    }
                    break
                }
            }
            .publishDecodable(type: [LogbookModel].self, decoder: decoder)
//            .sink { completion in
//                switch(completion) {
//                case .finished:
//                    ()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    self.errorMessage = error.localizedDescription
//                    self.showAlert = true
//                }
//            } receiveValue: { [weak self](response) in
////                withAnimation {
//
//                    switch response.result {
//                    case .success(let logbooks):
//                        self?.originalLogbooks = logbooks.map{ LogbookModel(with: $0)}
//                        self?.isLoading = false
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                        self?.errorMessage = error.localizedDescription
//                        self?.showAlert = true
////                    }
//                }
//
//            }

            .tryMap {$0.value}
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.logbooks)}
            .sink { [weak self] in
                self?.currentPage += 1
                self?.logbooks.append(contentsOf: $0 ?? [])
                self?.isLoading = false
                // If count of data receieved is less than perPage value then it is last page
                // TODO: Impl in backend

                if $0!.count < self!.perPage {
                    self?.logbookListFull = true
                }
            }
        
        
//            .publishUnserialized()
//            .tryMap { $0.data! }
//            .decode(type: [LogbookModel].self, decoder: decoder)
//            .receive(on: RunLoop.main)
//            .catch { _ in Just(self.logbooks) }
//            .sink { [weak self] in
//                print("3")
//                self?.currentPage += 1
//                self?.logbooks.append(contentsOf: $0)
//                print("1")
//                // If count of data receieved is less than perPage value then it is last page
//                // TODO: Impl in backend
//
//                if $0.count < self!.perPage {
//                    self?.logbookListFull = true
//                }
//            }
//            .responseDecodable(of: [LogbookModel].self, decoder: decoder) { (response) in
//
//                withAnimation {
//                    self.originalLogbooks = response.value ?? []
//                }
//            }
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
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
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
