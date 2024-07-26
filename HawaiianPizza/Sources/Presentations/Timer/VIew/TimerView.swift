//
//  TimerView.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 7/26/24.
//

import SwiftUI

struct DummyTask: Identifiable {
    var id: UUID = UUID()
    var taskTime: TimeInterval
    var taskSkipTime: TimeInterval
    var taskName: String
    var iconName: String
}

struct TimerView: View {
    @State private var progress: CGFloat = 1.0
    @State private var timer: Timer?
    @State private var currentTaskIndex: Int = 0
    @State private var remainingTime: TimeInterval = 0
    @State private var totalSkipTime: TimeInterval = 0
    
    let dummytasks = [
        DummyTask(taskTime: 10, taskSkipTime: 10, taskName: "Task 1", iconName: "tshirt"),
        DummyTask(taskTime: 6, taskSkipTime: 15, taskName: "Task 2", iconName: "tshirt.fill"),
        DummyTask(taskTime: 5, taskSkipTime: 20, taskName: "Task 3", iconName: "tshirt"),
        DummyTask(taskTime: 6, taskSkipTime: 15, taskName: "Task 4", iconName: "tshirt.fill"),
        DummyTask(taskTime: 5, taskSkipTime: 20, taskName: "Task 5", iconName: "tshirt")
    ]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(0..<3) { index in
                    let adjustedIndex = currentTaskIndex + index - 1
                    if let task = getTask(at: adjustedIndex) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: index == 1 ? 74 : 60, height: index == 1 ? 74 : 60)
                            Image(systemName: task.iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: index == 1 ? 50 : 40, height: index == 1 ? 50 : 40)
                        }
                        if index < 2 && (currentTaskIndex != 0 || index != 0) && (currentTaskIndex != dummytasks.count - 1 || index != 1) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 60, height: 2)
                        }
                    }
                }
            }
            .padding()
            
            Text(dummytasks[currentTaskIndex].taskName)
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .padding(.top, 40)
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 200)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.gray, lineWidth: 50)
                    .frame(width: 250, height: 250)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1.0), value: progress)
                Image(systemName: dummytasks[currentTaskIndex].iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            .padding()
            
            Spacer()
            
            Text("남은 시간")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .padding(.top, 20)
            
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 90, height: 90)
                    Text(String(format: "%02d", Int(remainingTime) / 60))
                        .font(.system(size: 50, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                }
                Text(":")
                    .font(.system(size: 50, weight: .bold))
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 90, height: 90)
                    Text(String(format: "%02d", Int(remainingTime) % 60))
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            Button(action: {
                nextTask()
            }) {
                Text(currentTaskIndex == dummytasks.count - 1 ? "완료" : "다음 루틴")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            startTask()
        }
    }
    
    func getTask(at index: Int) -> DummyTask? {
        guard index >= 0 && index < dummytasks.count else { return nil }
        return dummytasks[index]
    }
    
    func nextTask() {
        if currentTaskIndex < dummytasks.count - 1 {
            totalSkipTime += dummytasks[currentTaskIndex].taskSkipTime
            currentTaskIndex += 1
            startTask()
        } else {
            timer?.invalidate()
            progress = 0.0
        }
    }
    
    func startTask() {
        remainingTime = dummytasks[currentTaskIndex].taskTime
        progress = 1.0
        startTimer()
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
                progress = CGFloat(remainingTime) / CGFloat(dummytasks[currentTaskIndex].taskTime)
            } else {
                nextTask()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
