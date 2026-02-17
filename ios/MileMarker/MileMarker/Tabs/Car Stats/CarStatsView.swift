//
//  CarStatsView.swift
//  MileMarker
//
//  Created by Sharon To on 2/16/26.
//

import SwiftUI

struct CarStatsView: View {
    var vehicle: Vehicle
    
    @Environment(DataContainer.self) private var dataContainer
    var body: some View {
        Text("Stats")
    }
}

#Preview {
    CarStatsView(vehicle: .sampleData[0])
        .sampleDataContainer()
}
