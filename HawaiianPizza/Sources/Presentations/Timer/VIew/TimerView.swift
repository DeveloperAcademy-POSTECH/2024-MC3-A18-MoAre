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
        VStack(spacing: 0) {
            Text("Daily Routine")
                .font(
                    Font.custom("Pretendard Variable", size: 24)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.21, green: 0.22, blue: 0.23))
                .frame(width: 361, height: 42, alignment: .center)
                .padding(.top, 20)
            
            Spacer().frame(height: 46) // 데일리 루틴과 현재 단계 텍스트들 사이 간격을 좁게 설정
            
            Text("현재 단계")
                .font(
                    Font.custom("Pretendard Variable", size: 20)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.21, green: 0.22, blue: 0.23))
                .padding(.bottom, 4) // 현재 단계와 현재 단계 task의 사이 간격을 좁게 설정
            
            VStack(spacing: 0) {
                // 현재 작업
                Text(timerManager.tasks[timerManager.currentTaskIndex].taskName)
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(red: 1, green: 0.39, blue: 0.29))  // 텍스트 색상 설정
                    .padding(.bottom, 8) // 현재 단계와 다음 단계 사이의 구분선 간격을 좁게 설정
                
                // 현재 작업과 다음 작업 사이의 구분선
                if timerManager.currentTaskIndex < timerManager.tasks.count - 1 {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .padding(.bottom, 8) // 구분선과 다음 단계 task 사이의 간격을 좁게 설정
                    
                    Text(timerManager.tasks[timerManager.currentTaskIndex + 1].taskName)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.bottom, 16) // 다음 단계 task와 타이머 ZStack 사이 간격을 좁게 설정
                } else {
                   
                    Spacer().frame(height: 60)
                }
            }
            
            ZStack {
                Image("timer")
                    .resizable()
                    .frame(width: 276, height: 276)
                
                Circle()
                    .trim(from: 0, to: timerManager.progress)  // 진행 상태가 시계방향으로 줄어들도록 설정
                    .stroke(Color(red: 1, green: 0.39, blue: 0.29), lineWidth: 70)
                    .frame(width: 168, height: 168)
                    .rotationEffect(.degrees(-90))  // 12시 방향에서 시작
                    .scaleEffect(x: -1, y: 1, anchor: .center)  // 좌우 반전
                    .animation(timerManager.progress == 0 ? .linear(duration: 0.9) : .none, value: timerManager.progress)  // 회전 애니메이션 적용
                
                Image("timer center")
                    .resizable()
                    .frame(width: 294, height: 294)
                
                Image(systemName: timerManager.tasks[timerManager.currentTaskIndex].taskIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
            }
            .padding(.bottom, 38) // 타이머 ZStack과 남은 시간 Text 사이 간격을 좁게 설정
            
            Text("남은 시간")
                .font(
                    Font.custom("Pretendard Variable", size: 12)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.6, green: 0.62, blue: 0.64))
                .padding(.bottom, 10) // 남은 시간 Text와 타이머 텍스트 사이의 간격을 좁게 설정
            
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
            .padding(.bottom, 20) // 타이머 텍스트와 다음 루틴 버튼 사이의 간격을 좁게 설정
            
            Button(action: {
                timerManager.nextTask()
                HapticHelper.triggerSuccessHaptic()
            }) {
                Text(timerManager.currentTaskIndex == timerManager.tasks.count - 1 ? "완료" : "다음 루틴")
                    .font(Font.custom("Pretendard Variable", size: 20).weight(.heavy)) // Pretendard Variable 폰트와 heavy weight 사용
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white) // 텍스트 색상을 white로 설정
                    .padding(.vertical, 12) // vertical padding을 12로 설정
                    .frame(width: 361, alignment: .center) // 너비와 정렬 설정
                    .background(Color(red: 1, green: 0.39, blue: 0.29)) // 배경색 설정
                    .cornerRadius(8) // 코너 반경 설정
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            timerManager.startTask()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            timerManager.handleScenePhaseChange(newPhase)
        }
    }
}
