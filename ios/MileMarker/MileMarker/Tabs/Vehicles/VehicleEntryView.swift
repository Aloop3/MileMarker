//
//  VehicleEntryView.swift
//  MileMarker
//
//  Created by Sharon To on 2/12/26.
//

import SwiftUI

struct VehicleEntryView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    VehicleEntryView()
}
