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

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 200, height: 200)
                    Circle()
                        .trim(from: 0, to: timerManager.progress)
                        .stroke(Color.red, lineWidth: 50)
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(-90))
                        .animation(timerManager.progress == 0 ? .linear(duration: 0.9) : .none, value: timerManager.progress)  // 회전 애니메이션 적용
                    
                    Text("\(timerManager.remainingTime)")
                        .font(.system(size: 100, weight: .bold))
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
        .onAppear {
            timerManager.startCountdown()
            timerManager.$shouldNavigate
                .sink { shouldNavigate in
                    if shouldNavigate {
                        coordinator.push(destination: .timer)
                    }
                }
                .store(in: &cancellables)
        }
    }
}

struct TenSecView_Previews: PreviewProvider {
    static var previews: some View {
        TenSecView()
            .environmentObject(Coordinator())  // 미리보기에서 Coordinator 제공
    }
}
