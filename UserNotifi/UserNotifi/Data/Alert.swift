//
//  Alert.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/11.
//

import UIKit

struct Alert: Codable, Equatable {
    
    var id: String = UUID().uuidString
    var category: String
    var date: Date
    var repeatNoti: Bool
    var repeatCycle: Date
    var title: String
    var memo: String
    var flag: Bool
    var isOn: Bool
    
    var dateFormatter: String
    var timeFormatter: String
    var meridiemFormatter: String
    var repeatCycleFormatter: String
    
    static var dateDictionary = [String: [Alert]]()
    static var dateArray = [String]()
    static var categoryDictionary = ["미리알림": [Alert]()]
    static var categoryArray = ["미리알림"]
    static var alerts = [Alert]()
    
    init(category: String, date: Date, repeatNoti: Bool, repeatCycle: Date, repeatCycleFormatter: String, dateFormatter: String, timeFormatter: String, meridiemFormatter: String, title: String, memo: String, flag: Bool, isOn: Bool) {
        self.category = category
        self.date = date
        self.repeatNoti = repeatNoti
        self.repeatCycle = repeatCycle
        self.dateFormatter = dateFormatter
        self.timeFormatter = timeFormatter
        self.meridiemFormatter = meridiemFormatter
        self.repeatCycleFormatter = repeatCycleFormatter
        self.title = title
        self.memo = memo
        self.flag = flag
        self.isOn = isOn
    }
}
