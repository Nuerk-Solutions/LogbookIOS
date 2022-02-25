//
//  ShareSheet.swift
//  Logbook
//
//  Created by Thomas on 24.02.22.
//
import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        controller.isModalInPresentation = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        uiViewController.completionWithItemsHandler = { activity, completed, returnedItems, activityError in
            print(activity, completed, returnedItems, activityError)
            if activity == UIActivity.ActivityType.init(rawValue: "com.apple.DocumentManagerUICore.SaveToFiles") {
                do {
                    let firstItem = activityItems.first as! URL
                guard
                    let url = URL(string: firstItem.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://"))
                else {
                    throw APIError.invalidURL
                }
                UIApplication.shared.open(url)
                } catch {
                    print(error)
                }
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheet(activityItems: ["A string" as NSString])
    }
}
