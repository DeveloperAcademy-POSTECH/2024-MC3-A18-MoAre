//
//  CompleteView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/28/24.
//

import SwiftUI

struct CompleteView: View {
    @StateObject private var viewModel = CompleteViewModel()
    
    var body: some View {
        VStack {
            LottieView(loopMode: .playOnce, jsonName: "complete")
        }
    }
}

#Preview {
    CompleteView()
}
