//
//  CoreDataTestView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//

import SwiftUI

struct CoreDataTestView: View {
    @StateObject private var viewModel = CoreDataTestViewModel()
    @State private var routineTitle: String = ""
    @State private var routineTime: String = ""
    @State private var totalSkipTime: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("New Routine")) {
                        TextField("Routine Title", text: $routineTitle)
                        TextField("Routine Time (seconds)", text: $routineTime)
                            .keyboardType(.numberPad)
                        TextField("Total Skip Time (seconds)", text: $totalSkipTime)
                            .keyboardType(.numberPad)

                        Button(action: {
                            guard let routineTimeInt = Int(routineTime), let totalSkipTimeInt = Int(totalSkipTime) else {
                                return
                            }
                            viewModel.addRoutine(routineTitle: routineTitle, routineTime: routineTimeInt, skipTime: totalSkipTimeInt)
                            routineTitle = ""
                            routineTime = ""
                            totalSkipTime = ""
                        }) {
                            Text("Add Routine")
                        }
                    }
                }

                List {
                    ForEach(viewModel.routines, id: \.self) { routine in
                        VStack(alignment: .leading) {
                            Text(routine.routineTitle ?? "No Title")
                                .font(.headline)
                            Text("Time: \(routine.routineTime) seconds")
                            Text("Skip Time: \(routine.totalSkipTime) seconds")
                        }
                    }
                    .onDelete { offsets in
                        viewModel.deleteRoutines(offset: offsets)
                    }
                }
            }
            .navigationTitle("Routines")
            .toolbar {
                EditButton()
            }
        }
    }
}

#Preview {
    CoreDataTestView()
}
