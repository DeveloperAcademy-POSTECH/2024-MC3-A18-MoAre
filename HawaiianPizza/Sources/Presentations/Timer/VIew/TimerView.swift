//
//  TimerView.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 7/26/24.
//


import SwiftUI

struct TimerView: View {
    @StateObject private var timerManager = TimerViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(0..<3) { index in
                    let adjustedIndex = timerManager.currentTaskIndex + index - 1
                    if let task = timerManager.getTask(at: adjustedIndex) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: index == 1 ? 74 : 60, height: index == 1 ? 74 : 60)
                            Image(systemName: task.iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: index == 1 ? 50 : 40, height: index == 1 ? 50 : 40)
                        }
                        if index < 2 && (timerManager.currentTaskIndex != 0 || index != 0) && (timerManager.currentTaskIndex != timerManager.dummytasks.count - 1 || index != 1) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 60, height: 2)
                        }
                    }
                }
            }
            .padding()
            
            Text(timerManager.dummytasks[timerManager.currentTaskIndex].taskName)
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .padding(.top, 40)
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 200)
                Circle()
                    .trim(from: 0, to: timerManager.progress)
                    .stroke(Color.gray, lineWidth: 50)
                    .frame(width: 250, height: 250)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.3), value: timerManager.progress)
                Image(systemName: timerManager.dummytasks[timerManager.currentTaskIndex].iconName)
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
                    Text(String(format: "%02d", Int(timerManager.remainingTime) / 60))
                        .font(.system(size: 50, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                }
                Text(":")
                    .font(.system(size: 50, weight: .bold))
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 90, height: 90)
                    Text(String(format: "%02d", Int(timerManager.remainingTime) % 60))
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            Button(action: {
                timerManager.nextTask()
            }) {
                Text(timerManager.currentTaskIndex == timerManager.dummytasks.count - 1 ? "완료" : "다음 루틴")
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
            timerManager.startTask()
        }
        .onChange(of: scenePhase) { newPhase in
            timerManager.handleScenePhaseChange(newPhase)
        }
    }
}
