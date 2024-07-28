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
            Spacer()
            
            LottieView(loopMode: .playOnce, jsonName: "complete")
                .frame(width: 300, height: 300)
                .padding()
            Text("\(viewModel.completeRoutine?.totalSkipTime ?? 0)")
            
            Spacer()
        }
    }
}

#Preview {
    CompleteView()
}
