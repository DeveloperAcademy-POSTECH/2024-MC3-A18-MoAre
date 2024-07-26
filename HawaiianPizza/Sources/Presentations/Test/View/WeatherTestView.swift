//
//  WeatherTestView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/26/24.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Text("WeatherKit Test")
        }
        .task {
            await viewModel.fetchDailyWeather()
        }
    }
}

#Preview {
    WeatherView()
}
