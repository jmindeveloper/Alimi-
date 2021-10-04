//
//  UNNotificationCenter.swift
//  UserNotifi
//
//  Created by J_Min on 2021/10/04.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequest(by alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = "알림"
        content.body = alert.title
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
