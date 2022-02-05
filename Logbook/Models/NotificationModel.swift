//
//  NotificationModel.swift
//  Logbook
//
//  Created by Thomas on 05.02.22.
//

import Foundation
import UserNotifications

struct NotificationModel {
    
    let notificationId: String
    let title: String
    let body: String
    let sound: UNNotificationSound = .default
    let data: [String: Any]?
    let delay: TimeInterval = 1
}
