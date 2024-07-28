//
//  WeatherTestView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/26/24.
//

import SwiftUI
import CoreLocation

struct WeatherTestView: View {
    @StateObject private var viewModel = WeatherTestViewModel()
    
    var body: some View {
        VStack {
            if !viewModel.dailyWeather.isEmpty {
                Text("오늘의 날씨는 \(viewModel.dailyWeather[0].condition)")
                VStack {
                    Text("최저 기온:\(viewModel.dailyWeather[0].lowTemperature.value)")
                    Text("최고 기온: \(viewModel.dailyWeather[0].highTemperature.value)")
                }
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .task {
            await viewModel.fetchDailyWeather()
        }
    }
}

#Preview {
    WeatherTestView()
}
