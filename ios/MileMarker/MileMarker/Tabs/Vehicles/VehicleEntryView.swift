//
//  VehicleEntryView.swift
//  MileMarker
//
//  Created by Sharon To on 2/12/26.
//

import SwiftUI
import SwiftData

struct VehicleEntryView: View {
    @State private var make = ""
    @State private var model = ""
    @State private var nickname = ""
    @State private var year: Int = Calendar.current.component(.year, from: Date())
    @State private var odometer = ""
    
    @Environment(\.dismiss) private var dismiss
    @Environment(DataContainer.self) private var dataContainer
    var body: some View {
        NavigationStack {
            contentStack
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Add a new vehicle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark") {
                        let newVehicle = Vehicle(
                            nickname: nickname,
                            year: String(year),
                            make: make,
                            model: model,
                            lastOdometer: Int(odometer) ?? 0
                        )
                        dataContainer.context.insert(newVehicle)
                        do {
                            try dataContainer.context.save()
                            dismiss()
                        } catch {
                            // don't dismiss
                        }
                    }
                    .disabled(make.isEmpty || model.isEmpty || odometer.isEmpty)
                }
            }
        }
    }

    var contentStack: some View {
        Form {
            Section(header: Text("Vehicle Details")) {
                TextField("Nickname", text: $nickname)
                TextField("Make", text: $make)
                TextField("Model", text: $model)
                Picker("Year", selection: $year) {
                    ForEach((1980...Calendar.current.component(.year, from: Date())+1).reversed(), id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                TextField("Last Odometer", text: $odometer)
                    .keyboardType(.numberPad)
            }
        }
    }
}

#Preview {
    VehicleEntryView()
        .sampleDataContainer()
}
