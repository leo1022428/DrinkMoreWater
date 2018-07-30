//
//  WaterDetail.swift
//  DrinkMoreWater
//
//  Created by Che-wei LIU on 2018/7/18.
//  Copyright © 2018 Che-wei LIU. All rights reserved.
//

import Foundation

let unwindAddSegue = "unwindAddSegue"
let unwindEditSegue = "unwindEditSegue"
let unwindSettingSegue = "unwindSettingSegue"


enum DrinkWaterTime: String {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case exercise = "Exercise"
}

class WaterDetail: Codable{
    var water: Int
    var date: Date
    
    init(water: Int, date: Date) {
        self.water = water
        self.date = date
    }
    
}

