import SwiftUI

struct TestMain: View {
    @StateObject private var viewModel = TestMainViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.routines.isEmpty {
                    Text("No routines available")
                        .font(.title)
                        .padding()
                } else {
                    List(viewModel.routines, id: \.id) { item in
                        NavigationLink(destination: RoutineDetailView(routine: item)) {
                            VStack(alignment: .leading) {
                                Text(item.routineTitle ?? "No Title")
                                    .font(.headline)
                                Text("Total Skip Time: \(item.totalSkipTime)")
                                Text("Routine Time: \(item.routineTime)")
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                NavigationLink(destination: RoutineSettingView()) {
                    Text("Set a New Routine")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Routines")
            .onAppear {
                viewModel.fetchRoutine()
            }
        }
    }
}

#Preview {
    TestMain()
}
