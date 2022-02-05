//
//  NotificationService.swift
//  Logbook
//
//  Created by Thomas on 05.02.22.
//

import Foundation
import UserNotifications
import UIKit


class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All permissions Requested and set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func requestLocalNotification(notification: NotificationModel, removePendingRequest: Bool = true) {
        let center = UNUserNotificationCenter.current()
        if removePendingRequest {
        center.removeAllPendingNotificationRequests()
        }
        
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.sound = notification.sound
        
        if let data = notification.data {
            content.userInfo = data
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.delay, repeats: false) // Show notification 1 sec from now
        
        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: notification.notificationId, content: content, trigger: trigger)
        
        center.add(notificationRequest) { error in
            if let error = error {
                print(error)
            } else {
                print("Added Notification!")
            }
        }
    }
    
    func pushApplicationBadge(amount: Int = 1) {
        UIApplication.shared.applicationIconBadgeNumber = amount
    }
}
