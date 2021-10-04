//
//  UNNotificationCenter.swift
//  UserNotifi
//
//  Created by J_Min on 2021/10/04.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationReqyest(by alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = ""
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.day, .hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
    }
}
