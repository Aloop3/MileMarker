//
//  FuelLogView.swift
//  MileMarker
//
//  Created by Sharon To on 2/16/26.
//

import SwiftUI

struct FuelLogView: View {
    var vehicle: Vehicle
    
    @Environment(DataContainer.self) private var dataContainer
    var body: some View {
        Text("Fuel Log")
    }
}

#Preview {
    FuelLogView(vehicle: .sampleData[0])
        .sampleDataContainer()
}
