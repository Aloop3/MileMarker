//
//  VehiclesView.swift
//  MileMarker
//
//  List of vehicles the user owns
//
import SwiftData
import SwiftUI

struct VehiclesView: View {
    @State private var showAddVehicle: Bool = false
    @Query(sort: \Vehicle.nickname)
    private var vehicles: [Vehicle]
    
    var body: some View {
        NavigationStack {
            ScrollView{
                vehicleItems
                    .frame(maxWidth: .infinity)
            }
            .overlay {
                if vehicles.isEmpty {
                    ContentUnavailableView {
                        Label("No vehicles registered", systemImage: "exclamationmark.circle.fill")
                    } description: {
                        Text("Please add a vehicle to continue")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddVehicle = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showAddVehicle) {
                        VehicleEntryView()
                    }
                }
            }
            .navigationTitle("My Vehicles")
            .padding()
        }
    }
    
    private var vehicleItems: some View {
        ForEach(vehicles) { vehicle in
            Text(vehicle.nickname ?? "Car")
        }
    }
}

#Preview {
    VehiclesView()
        .sampleDataContainer()
}

#Preview("No vehicles") {
    VehiclesView()
        .modelContainer(for: [Vehicle.self])
}
