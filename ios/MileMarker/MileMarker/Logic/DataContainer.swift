//
//  DataContainer.swift
//  MileMarker
//
//  Created by Sharon To on 2/12/26.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
class DataContainer {
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    init(includeSampleVehicles: Bool = false) {
        let schema = Schema([
            Vehicle.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: includeSampleVehicles)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            if includeSampleVehicles {
                loadSampleVehicles()
            }
            try context.save()
        } catch {
            fatalError("Couldn't create ModelContainer: \(error)")
        }
    }
    
    private func loadSampleVehicles() {
        for vehicle in Vehicle.sampleData {
            context.insert(vehicle)
        }
    }
    
}

private let sampleContainer = DataContainer(includeSampleVehicles: true)

extension View {
    func sampleDataContainer() -> some View {
        self
            .environment(sampleContainer)
            .modelContainer(sampleContainer.modelContainer)
    }
}
