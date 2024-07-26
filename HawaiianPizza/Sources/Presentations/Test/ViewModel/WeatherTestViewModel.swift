//
//  WeatherTestViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/26/24.
//

import SwiftUI
import CoreLocation
import WeatherKit

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var dailyWeather: [DayWeather] = []
    @Published var errorMessage: String?
    let location = CLLocation(latitude: 36.014008452398, longitude: 129.3258174744)
    
    func fetchWeather() async {
        do {
            let current = try await WeatherHelper.shared.fetchCurrentWeather(location: location)
            DispatchQueue.main.async {
                self.currentWeather = current
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch weather: \(error)"
            }
        }
    }
    
    func fetchDailyWeather() async {
        do {
            let daily = try await WeatherHelper.shared.fetchDailyWeather(location: location)
            DispatchQueue.main.async {
                self.dailyWeather = daily.forecast
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch weather: \(error)"
            }
        }
    }
}
