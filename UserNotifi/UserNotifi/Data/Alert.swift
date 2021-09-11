//
//  Alert.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/11.
//

import UIKit

struct Alert: Codable {
    
    var id: String = UUID().uuidString
    var category: String
    let date: Date
    var repeatNoti: Bool
    var repeatCycle: Date
    var title: String
    var memo: String
    
    var dateFormatter: String
    var timeFormatter: String
    var meridiemFormatter: String
    
    init(category: String, date: Date, repeatNoti: Bool, repeatCycle: Date, dateFormatter: String, timeFormatter: String, meridiemFormatter: String, title: String, memo: String) {
        self.category = category
        self.date = date
        self.repeatNoti = repeatNoti
        self.repeatCycle = repeatCycle
        self.dateFormatter = dateFormatter
        self.timeFormatter = timeFormatter
        self.meridiemFormatter = meridiemFormatter
        self.title = title
        self.memo = memo
    }

}
