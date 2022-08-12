//
//  Pagination.swift
//  Logbook
//
//  Created by Thomas on 10.06.22.
//

import Foundation

actor PagingData {
    
    private(set) var currentPage = -1
    private(set) var hasReachEnd = false
    
    let itemsPerPage: Int
    let maxPageLimit: Int
    
    init(itemsPerPage: Int, maxPageLimit: Int) {
        assert(itemsPerPage > 0 && maxPageLimit > 0, "Items per page and max page limit must be greater than zero")
        
        self.itemsPerPage = itemsPerPage
        self.maxPageLimit = maxPageLimit
    }
    
    var nextPage: Int { currentPage + 1 }
    var canLoadNextPage: Bool {
        !hasReachEnd && nextPage <= maxPageLimit
    }
    
    func loadNextPage<T>(dataFetchProvider: @escaping (Int) async throws -> [T]) async throws -> [T] {
        if Task.isCancelled {
            return [] }
        
        print("--------------------------")
        print("[Paging-Manager]: Current Page \(currentPage), next page: \(nextPage)")
        
        guard canLoadNextPage else {
            print("[Paging-Manager]: Stop loading next page. Has reached end: \(hasReachEnd), next page: \(nextPage), max page limit: \(maxPageLimit)")
            return []
        }
        
        let nextPage = self.nextPage
        let items = try await dataFetchProvider(nextPage)
        
        if nextPage != self.nextPage || items.isEmpty {
            return []
        }
        
        currentPage = nextPage
        hasReachEnd = items.count < itemsPerPage
        
        print("[Paging-Manager]: Fetched \(items.count) items successfully. Current Page: \(currentPage)")
        print("--------------------------")
        return items
    }
    
    func reset() {
        print("\n[Paging-Manager]: ♻️ Reset\n")
        currentPage = -1
        hasReachEnd = false
    }
    
}
