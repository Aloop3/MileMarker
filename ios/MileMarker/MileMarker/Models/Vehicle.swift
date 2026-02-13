//
//  Vehicle.swift
//  MileMarker
//
//  Created by Sharon To on 2/12/26.
//

import Foundation
import SwiftData


@Model
class Vehicle {
    var nickname: String?
    var year: String
    var make: String
    var model: String
    var lastOdometer: Int
    
    init(nickname: String? = nil, year: String, make: String, model: String, lastOdometer: Int){
        self.nickname = nickname
        self.year = year
        self.make = make
        self.model = model
        self.lastOdometer = lastOdometer
    }
}

extension Vehicle {
    static let sampleData = [
        Vehicle(
            nickname: "Honda",
            year: "2009",
            make: "Honda",
            model: "Accord",
            lastOdometer: 100000
        ),
        Vehicle(
            nickname: "Mini",
            year: "2012",
            make: "Mini",
            model: "Cooper",
            lastOdometer: 70000
        )
    ]
}
