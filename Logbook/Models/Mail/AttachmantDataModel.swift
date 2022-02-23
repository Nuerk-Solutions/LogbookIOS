//
//  AttachmantDataModel.swift
//  Logbook
//
//  Created by Thomas on 23.02.22.
//

import Foundation

struct AttachmentData {
    public let data: Data
    public let mimeType: String
    public let fileName: String
    
    public init(data: Data,
                mimeType: String,
                fileName: String) {
        self.data = data
        self.mimeType = mimeType
        self.fileName = fileName
    }
}
