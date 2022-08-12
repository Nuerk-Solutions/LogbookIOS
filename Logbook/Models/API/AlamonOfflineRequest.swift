//
//  AlamonOfflineRequest.swift
//  Logbook
//
//  Created by Thomas on 07.08.22.
//

import Foundation

class AlamonOfflineRequest: NSObject, OfflineRequest {
    
    var completion: () -> ()
    let identifier: Int
    static var count = 1
    
    class func newRequest(completion: @escaping () -> ()) -> AlamonOfflineRequest {
        let request = AlamonOfflineRequest(identifier: count, completion: completion)
        count += 1
        return request
    }
    
    /// Initializer with an arbitrary number to demonstrate data persistence
    ///
    /// - Parameter identifier: arbitrary number
    init(identifier: Int, completion: @escaping () -> ()) {
        self.identifier = identifier
        self.completion = completion
        super.init()
    }
    
    /// Dictionary methods are optional for simple use cases, but required for saving to disk in the case of app termination
    required convenience init?(dictionary: [String : Any]) {
        guard let identifier = dictionary["identifier"] as? Int else { return  nil}
        self.init(identifier: identifier) {}
    }
    
    
    var dictionaryRepresentation: [String : Any]? {
        return ["identifier" : identifier]
    }
    
    func perform(completion: @escaping (Error?) -> Void) {
        self.completion()
    }
    
    
}
