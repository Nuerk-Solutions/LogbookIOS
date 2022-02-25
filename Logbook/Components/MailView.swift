//
//  MailView.swift
//  Logbook
//
//  Created by Thomas on 23.02.22.
//

import SwiftUI
import MessageUI
import UIKit

public typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

public struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var data: MailData
    
    let callback: MailViewCallback
    
    init(data: Binding<MailData>,
                callback: MailViewCallback) {
        _data = data
        self.callback = callback
    }

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var data: MailData
        let callback: MailViewCallback

        init(presentation: Binding<PresentationMode>, data: Binding<MailData>, callback: MailViewCallback) {
            _data = data
            _presentation = presentation
            self.callback = callback
        }

        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                callback?(.failure(error!))
                return
            }
            callback?(.success(result))
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation, data: $data, callback: callback)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(data.recipients)
        vc.setSubject(data.subject)
        data.attachments?.forEach {
            vc.addAttachmentData($0.data, mimeType: $0.mimeType, fileName: $0.fileName)
        }
        vc.setMessageBody(data.message, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        vc.accessibilityElementDidLoseFocus()
        return vc
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
    }
    
    public static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
}
