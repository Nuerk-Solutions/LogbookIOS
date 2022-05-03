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
    
    @Published var originalLogbooks = [LogbookModel]()
    @Published var invoiceLogbooks = [LogbookModel]()
    @Published var logbooks = [LogbookModel]()
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var searchTerm: String = ""
    
    @Published var isLoadingPage = false
    private var canLoadMorePages = true
    
    @Published var logbookListFull = false
    var currentPage = 0
    let perPage = 25
    
    
    let session: Session
    let interceptor: RequestInterceptor = Interceptor()
    
    
    init() {
        session = Session(interceptor: interceptor)
        //        Task {
        loadMoreContent(extend: true)
        //        }
        //        withAnimation {
        //            Publishers.CombineLatest($originalLogbooks, $searchTerm)
        //                .map { logbooks, searchTerm in
        //                    logbooks.filter { logbook in
        //                        searchTerm.isEmpty ? true : (logbook.driveReason.contains(searchTerm) || logbook.driver.id.contains(searchTerm))
        //                    }
        //                }
        //                .debounce(for: .seconds(1), scheduler: RunLoop.main)
        //                .assign(to: &$logbooks)
        //        }
    }
    
    func loadMoreContentIfNeeded(currentItem item: LogbookModel?) {
        guard let item = item else {
            loadMoreContent(extend: true)
            return
        }
        
        let thresholdIndex = originalLogbooks.index(originalLogbooks.endIndex, offsetBy: -5)
        if originalLogbooks.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent(extend: true)
        }
    }
    
    func refresh(extend: Bool = false) {
        withAnimation {
            self.currentPage = 0
            self.canLoadMorePages = true
            loadMoreContent(extend: extend)
        }
    }
    
    func loadMoreContent(extend: Bool = false) {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        let url = "https://api.nuerk-solutions.de/logbook/find/all?sort=-date&page=\(currentPage)&limit=\(perPage)"
        session.request(url, method: .get)
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
                        printError(description: "Pagination fetch more content", errorMessage: error.errorDescription)
                        break
                    }
                    print(error)
                case.success(_):
                    consoleManager.print("Feteched entries (\(self.currentPage) \(self.canLoadMorePages)")
                    withAnimation {
                        self.isLoading = false
                    }
                    break
                }
            }
            .responseDecodable(of: [LogbookModel].self, decoder: decoder) { (response) in
                withAnimation {
                    self.canLoadMorePages = response.value?.count == self.perPage
                    self.isLoadingPage = false
                    self.currentPage += 1
                    if (extend) {
                        self.originalLogbooks.append(contentsOf: response.value ?? [])
                        return
                    }
                    self.originalLogbooks = response.value ?? []
                }
            }
    }
    
    func fetchLogbooksForDriver(driver: DriverEnum, startDate: Date, endDate: Date) {
        showAlert = false
        errorMessage = nil
        withAnimation {
            isLoading.toggle()
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standardT)
        session.request("https://api.nuerk-solutions.de/logbook/find/all?sort=-date&drivers=\(driver)&startDate=\(DateFormatter.yearMonthDay.string(from: startDate))&endDate=\(DateFormatter.yearMonthDay.string(from: endDate))", method: .get)
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
            .responseDecodable(of: [LogbookModel].self, decoder: decoder) { (response) in
                withAnimation {
                    self.invoiceLogbooks = response.value ?? []
                }
            }
    }
}
