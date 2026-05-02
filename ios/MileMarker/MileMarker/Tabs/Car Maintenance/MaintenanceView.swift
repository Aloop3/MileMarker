//
//  MaintenanceView.swift
//  MileMarker
//
//  Created by Sharon To on 2/16/26.
//

import SwiftUI

struct MaintenanceView: View {
    var vehicle: Vehicle
    
    @Environment(DataContainer.self) private var dataContainer
    var body: some View {
        Text("Maintenance")
    }
}

#Preview {
    MaintenanceView(vehicle: .sampleData[0])
        .sampleDataContainer()
}
