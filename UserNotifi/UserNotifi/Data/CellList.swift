//
//  CellectCellOption.swift
//  UserNotifi
//
//  Created by J_Min on 2021/09/10.
//

import UIKit

struct CellList {
    var date: String
    var count: Int
    var image: String
    
    init(date: String, count: Int, image: String) {
        self.date = date
        self.count = count
        self.image = image
    }
}

struct Category: Codable {
    var categoryName: String
    var count: Int
    var image: String
    var imageColor: String
    
    init(categoryName: String, count: Int, image: String, imageColor: String) {
        self.categoryName = categoryName
        self.count = count
        self.image = image
        self.imageColor = imageColor
    }
}
