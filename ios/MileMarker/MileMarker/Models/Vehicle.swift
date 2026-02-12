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
    var last_odometer: Int?
    
    init(nickname: String? = nil, year: String, make: String, model: String, last_odometer: Int? = nil){
        self.nickname = nickname
        self.year = year
        self.make = make
        self.model = model
        self.last_odometer = last_odometer
    }
}

extension Vehicle {
    static let sampleData = [
        Vehicle(
            nickname: "Honda",
            year: "2009",
            make: "Honda",
            model: "Accord",
            last_odometer: 100000
        ),
        Vehicle(
            nickname: "Mini",
            year: "2012",
            make: "Mini",
            model: "Cooper",
            last_odometer: 70000
        )
    ]
}
