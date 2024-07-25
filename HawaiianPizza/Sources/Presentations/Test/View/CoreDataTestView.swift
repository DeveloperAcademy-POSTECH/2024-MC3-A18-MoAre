//
//  CoreDataTestView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//

import SwiftUI

struct CoreDataTestView: View {
    @StateObject private var viewModel = CoreDataTestViewModel()
    
    @State private var showingAddRoutineSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.routines, id: \.id) { routine in
                    VStack(alignment: .leading) {
                        Text(routine.routineTitle)
                            .font(.headline)
                        Text("Time: \(routine.routineTime, formatter: dateFormatter)")
                        Text("Skip Time: \(routine.totalSkipTime ?? Date(), formatter: dateFormatter)")
                    }
                }
                .onDelete(perform: viewModel.deleteRoutines)
            }
            .navigationTitle("Routines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddRoutineSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .onAppear {
            viewModel.fetchRoutines()
        }
        .sheet(isPresented: $showingAddRoutineSheet) {
            AddRoutineView(viewModel: viewModel)
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

struct AddRoutineView: View {
    @ObservedObject var viewModel: CoreDataTestViewModel
    
    @State private var newRoutineTitle: String = ""
    @State private var newRoutineTime: Date = Date()
    @State private var newSkipTime: Date = Date()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Routine Title", text: $newRoutineTitle)
                DatePicker("Routine Time", selection: $newRoutineTime, displayedComponents: .hourAndMinute)
                DatePicker("Skip Time", selection: $newSkipTime, displayedComponents: .hourAndMinute)
                Button(action: {
                    viewModel.addRoutine(routineTitle: newRoutineTitle, routineTime: newRoutineTime, skipTime: newSkipTime)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Routine")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Add Routine")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CoreDataTestView()
}
