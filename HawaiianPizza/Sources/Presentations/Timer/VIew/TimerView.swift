//
//  TimerView.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 7/26/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var timerManager: TimerViewModel
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var coordinator: Coordinator

    init(routineID: String) {
        let manager = TimerViewModel.shared // 싱글톤 인스턴스 사용
        manager.loadRoutine(with: routineID)
        _timerManager = StateObject(wrappedValue: manager) // 초기화
        print("TimerView 초기화됨, routineID: \(routineID)")
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(timerManager.routineTitle)
                .font(
                    Font.custom("Pretendard Variable", size: 24)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.21, green: 0.22, blue: 0.23))
                .frame(width: 361, height: 42, alignment: .center)
                .padding(.top, 20)

            Spacer().frame(height: 46)

            Text("현재 단계")
                .font(
                    Font.custom("Pretendard Variable", size: 20)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.21, green: 0.22, blue: 0.23))
                .padding(.bottom, 4)

            VStack(spacing: 0) {
                if timerManager.currentTaskIndex < timerManager.tasks.count {
                    Text(timerManager.tasks[timerManager.currentTaskIndex].taskName ?? "태스크명이 없습니다")
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(red: 1, green: 0.39, blue: 0.29))
                        .padding(.bottom, 8)
                    
                    if timerManager.currentTaskIndex < timerManager.tasks.count - 1 {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                            .padding(.bottom, 8)
                        
                        Text(timerManager.tasks[timerManager.currentTaskIndex + 1].taskName ?? "태스크명이 없습니다")
                            .font(.system(size: 24, weight: .medium))
                    }
                } else {
                    Text("유효한 태스크가 없습니다")
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(red: 1, green: 0.39, blue: 0.29))
                        .padding(.bottom, 8)
                }
            }

            ZStack {
                Image("timer")
                    .resizable()
                    .frame(width: 276, height: 276)

                Circle()
                    .trim(from: 0, to: timerManager.progress)
                    .stroke(Color(red: 1, green: 0.39, blue: 0.29), lineWidth: 70)
                    .frame(width: 168, height: 168)
                    .rotationEffect(.degrees(-90))
                    .scaleEffect(x: -1, y: 1, anchor: .center)
                    .animation(timerManager.progress == 0 ? .linear(duration: 0.9) : .none, value: timerManager.progress)

                Image("timer center")
                    .resizable()
                    .frame(width: 294, height: 294)

                if timerManager.currentTaskIndex < timerManager.tasks.count {
                    Image(timerManager.tasks[timerManager.currentTaskIndex].taskIcon ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                } else {
                    Text("아이콘 없음")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 38)

            Text("남은 시간")
                .font(
                    Font.custom("Pretendard Variable", size: 12)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.6, green: 0.62, blue: 0.64))
                .padding(.bottom, 10)

            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 220, height: 80)
                    .background(Color(red: 0.92, green: 0.93, blue: 0.91))
                    .cornerRadius(40)
                HStack(spacing: 10) {
                    Text(String(format: "%02d : %02d", Int(timerManager.remainingTime) / 60, Int(timerManager.remainingTime) % 60))
                        .font(
                            Font.custom("Pretendard Variable", size: 48)
                                .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.21, green: 0.22, blue: 0.23))
                        .frame(width: 220, height: 80, alignment: .center)
                }
            }
            .padding(.bottom, 20)

            Button(action: {
                        if timerManager.currentTaskIndex == timerManager.tasks.count - 1 {
                                    timerManager.completeRoutine()
                                    coordinator.push(destination: .complete)
                                    print("마지막 태스크 완료, 완료 화면으로 이동")
                                } else {
                                    timerManager.nextTask()
                                    print("다음 루틴 버튼 클릭됨")
                                }
                                HapticHelper.triggerSuccessHaptic()
                    }
            ) {
                Text(timerManager.currentTaskIndex == timerManager.tasks.count - 1 ? "완료" : "다음 루틴")
                    .font(Font.custom("Pretendard Variable", size: 20).weight(.heavy))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(width: 361, alignment: .center)
                    .background(Color(red: 1, green: 0.39, blue: 0.29))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            print("TimerView 나타남, 루틴 시작")
            timerManager.startTask()  // 여기에 startTask를 호출하여 타이머 시작
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
        }
        .onDisappear {
            timerManager.stopTimer()
            timerManager.endLiveActivity()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(routineID: "SampleRoutineID")
    }
}
