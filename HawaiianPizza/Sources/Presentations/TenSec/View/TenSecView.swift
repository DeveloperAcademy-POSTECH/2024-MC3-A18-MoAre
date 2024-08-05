//
//  TenSecView.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 8/1/24.
//

import SwiftUI
import Combine

struct TenSecView: View {
    @StateObject private var timerManager = TenSecViewModel()
    @EnvironmentObject var coordinator: Coordinator  // Coordinator를 EnvironmentObject로 추가
    @State private var cancellables = Set<AnyCancellable>() // Combine cancellables를 @State로 정의
  
    var routineID: String?

    var body: some View {
      NavigationStack(path: $coordinator.path) {
        VStack {
          if let routine = timerManager.routine {
            Text(routine.routineTitle ?? "루틴명이 없습니다")
              .font(
                Font.custom("Pretendard Variable", size: 24)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.21, green: 0.22, blue: 0.23))
              .frame(width: 361, height: 42, alignment: .center)
            Spacer()
            
            
            HStack {
              Spacer()
              ZStack {
                Image("timer")
                  .resizable()
                  .frame(width: 276, height: 276)
                
                Circle()
                  .trim(from: 0, to: timerManager.progress)  // 진행 상태가 시계방향으로 줄어들도록 설정
                  .stroke(Color(red: 1, green: 0.39, blue: 0.29), lineWidth: 70) // 변경된 색상
                  .frame(width: 168, height: 168)
                  .rotationEffect(.degrees(-90))  // 12시 방향에서 시작
                  .scaleEffect(x: -1, y: 1, anchor: .center)  // 좌우 반전
                  .animation(timerManager.progress == 0 ? .linear(duration: 0.9) : .none, value: timerManager.progress)  // 회전 애니메이션 적용
                
                Image("timer center")
                  .resizable()
                  .frame(width: 294, height: 294)
                
                Text("\(timerManager.remainingTime)")
                  .font(
                    Font.custom("Pretendard Variable", size: 64)
                      .weight(.heavy)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.21, green: 0.22, blue: 0.23))
                  .frame(width: 160, height: 94, alignment: .center)
              }
              Spacer()
            }
          }
          
          Spacer()
          
          // "바로 시작" 버튼 추가
          Button(action: {
            coordinator.push(destination: .timer)
            HapticHelper.triggerSuccessHaptic()
          }) {
            Text("바로 시작")
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(.white)
            
          }
          .padding(.horizontal, 0)
          .padding(.vertical, 12)
          .frame(width: 361, alignment: .center)
          .background(Color(red: 1, green: 0.39, blue: 0.29)) // 버튼 색상
          .cornerRadius(8)  // 하단 여백 추가
          
        }
        .padding()
        .onAppear {
          timerManager.startCountdown()
          if let routineID = routineID {
            timerManager.loadRoutine(with: routineID)
          }
          timerManager.$shouldNavigate
            .sink { shouldNavigate in
              if shouldNavigate {
                coordinator.push(destination: .timer)
              }
            }
            .store(in: &cancellables)
        }
        .navigationDestination(for: ViewDestination.self){ destination in
          coordinator.setView(destination: destination)
        }
      }
    }
}

struct TenSecView_Previews: PreviewProvider {
    static var previews: some View {
        TenSecView()
            .environmentObject(Coordinator())  // 미리보기에서 Coordinator 제공
    }
}
