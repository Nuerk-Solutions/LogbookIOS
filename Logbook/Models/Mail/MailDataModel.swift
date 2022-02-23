//
//  MailDataModel.swift
//  Logbook
//
//  Created by Thomas on 23.02.22.
//

import Foundation

struct MailData {
    public let subject: String
    public let recipients: [String]?
    public let message: String
    public let attachments: [AttachmentData]?
    
    public init(subject: String,
                recipients: [String]?,
                message: String,
                attachments: [AttachmentData]?) {
        self.subject = subject
        self.recipients = recipients
        self.message = message
        self.attachments = attachments
    }
    
    public static let empty = MailData(subject: "", recipients: nil, message: "", attachments: nil)
    
}
