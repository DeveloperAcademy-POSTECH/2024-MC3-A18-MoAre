//
//  WeatherTestViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/26/24.
//

import SwiftUI
import CoreLocation
import WeatherKit

class WeatherTestViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var dailyWeather: [DayWeather] = []

    let location = CLLocation(latitude: 36.014008452398, longitude: 129.3258174744)
    
    func fetchCurrentWeather() async {
        do {
            let current = try await WeatherHelper.shared.fetchCurrentWeather(location: location)
            DispatchQueue.main.async {
                self.currentWeather = current
            }
        } catch {
              print("Failed to fetch weather: \(error)")
        }
    }
    
    func fetchDailyWeather() async {
        do {
            let daily = try await WeatherHelper.shared.fetchDailyWeather(location: location)
            DispatchQueue.main.async {
                self.dailyWeather = daily.forecast
                for day in daily {
                    print("-----")
                    print("날씨 \(day.condition)")
                    print("최고 기온 \(day.highTemperature)")
                    print("최저 기온 \(day.lowTemperature)")
                    print("비: \(day.precipitation)")
                    print("강수량 \(day.precipitationAmount)")
                    print("강수 확률 \(day.precipitationChance)")
                    print("-----")
                }
            }
        } catch {
                print("Failed to fetch weather: \(error)")
        }
    }
}
