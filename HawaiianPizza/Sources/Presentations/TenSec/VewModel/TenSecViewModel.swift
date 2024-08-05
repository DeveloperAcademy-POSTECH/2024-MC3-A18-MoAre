//
//  TenSecViewModel.swift
//  HawaiianPizza
//
//  Created by Pil_Gaaang on 8/1/24.
//

import SwiftUI
import Combine

class TenSecViewModel: ObservableObject {
    @Published var remainingTime: Int = 10
    @Published var progress: CGFloat = 1.0
    @Published var shouldNavigate: Bool = false  // Navigation 상태 추가
    @Published var routine: Routine? // Routine 객체를 저장할 프로퍼티
    var timer: Timer?

    func startCountdown() {
        resetCountdown()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1

                // 진행 상태를 천천히 줄이기
                withAnimation(.linear(duration: 0.9)) {
                    self.progress = 0.0
                }

                // 0.9초 후에 진행 상태를 빠르게 1로 설정
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    withAnimation(.linear(duration: 0.1)) {
                        self.progress = 1.0
                    }
                }
            } else {
                self.timer?.invalidate()
                self.shouldNavigate = true  // 카운트다운이 끝나면 상태 변경
            }
        }
    }

    func resetCountdown() {
        self.remainingTime = 10
        self.progress = 1.0
        self.shouldNavigate = false  // 상태 초기화
    }
  
    func loadRoutine(with routineID: String) {
      guard let uuid = UUID(uuidString: routineID) else { return }
      self.routine = CoreDataManager.shared.fetchRoutine(by: uuid)
    }
}
