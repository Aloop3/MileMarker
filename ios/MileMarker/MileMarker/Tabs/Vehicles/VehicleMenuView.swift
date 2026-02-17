//
//  VehicleMenuView.swift
//  MileMarker
//
//  Created by Sharon To on 2/16/26.
//

import SwiftUI
import SwiftData

struct VehicleMenuView: View {
    @State private var selectedTab: Int = 0
    @State private var showFuelLog = false
    @State private var showMaintenance = false
    @State private var showStats = false
    var vehicle: Vehicle
    
    @Environment(DataContainer.self) private var dataContainer
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                contentStack
                    .navigationTitle(vehicle.nickname ?? vehicle.make)
                    .navigationBarTitleDisplayMode(.large)
                    .padding()
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(1)
            FuelLogView(vehicle: vehicle)
                .tabItem {
                    Image(systemName: "fuelpump")
                    Text("Fuel Log")
                }
                .tag(2)
            MaintenanceView(vehicle: vehicle)
                .tabItem {
                    Image(systemName: "car")
                    Text("Maintenance")
                }
                .tag(3)
            CarStatsView(vehicle: vehicle)
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Stats")
                }
                .tag(4)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 1 {
                // Reset booleans here
                showFuelLog = false
                showMaintenance = false
                showStats = false
            }
        }
    }
    
    private var contentStack: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    showFuelLog = true
                    showMaintenance = false
                    showStats = false
                    selectedTab = 2
                }) {
                    Label("Add Fuel Log", systemImage: "fuelpump")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 20, leading: 55, bottom: 20, trailing: 55))
                        .background(Color.primary)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationDestination(isPresented: $showFuelLog) {
                FuelLogView(vehicle: vehicle)
            }
            VStack {
                Button(action: {
                    showMaintenance = true
                    showFuelLog = false
                    showStats = false
                    selectedTab = 3
                }) {
                    Label("Add Car Maintenance", systemImage: "car")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.primary)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationDestination(isPresented: $showMaintenance) {
                MaintenanceView(vehicle: vehicle)
            }
            VStack {
                Button(action: {
                    showStats = true
                    showFuelLog = false
                    showMaintenance = false
                    selectedTab = 4
                }) {
                    Label("View Car Stats", systemImage: "chart.bar.xaxis")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 20, leading: 48, bottom: 20, trailing: 48))
                        .background(Color.primary)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationDestination(isPresented: $showStats) {
                CarStatsView(vehicle: vehicle)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    VehicleMenuView(vehicle: .sampleData[0])
        .sampleDataContainer()
}
