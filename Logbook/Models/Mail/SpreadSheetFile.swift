//
//  FileDocument.swift
//  Logbook
//
//  Created by Thomas on 24.02.22.
//

import SwiftUI
import UniformTypeIdentifiers

struct SpreadSheetFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes: [UTType] = [UTType.spreadsheet]
    
    var data: Data
    var filename: String
    
    // a simple initializer that creates new, empty documents
    init(data: Data, filename: String) {
        self.data = data
        self.filename = filename
    }


    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        data = Data()
        filename = ""
//        url = nil
//        if let data = configuration.file.regularFileContents {
//            spreadSheet = String(decoding: data, as: UTF8.self)
//        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        fileWrapper.filename = filename
        return fileWrapper
    }
}
