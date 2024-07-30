//
//  Lottie.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/28/24.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    let loopMode: LottieLoopMode
    let jsonName: String

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: jsonName)
        animationView.play()
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // 업데이트 로직이 필요한 경우 여기에 추가합니다.
    }
}
