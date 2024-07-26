//
//  WeatherHelper.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/26/24.
//

import Foundation

import WeatherKit
import CoreLocation

final class WeatherHelper {
    
    static let shared: WeatherHelper = .init()
    
    private init() { }
    
    func fetchCurrentWeather(location: CLLocation) async throws -> CurrentWeather {
        let weather = try await WeatherService.shared.weather(for: location)
        let current = weather.currentWeather
        print("current: \(current)")
        return current
    }
    
    func fetchDailyWeather(location: CLLocation) async throws ->  Forecast<DayWeather> {
        let weather = try await WeatherService.shared.weather(for: location)
        let daily = weather.dailyForecast
        print("daily: \(daily)")
        return daily
    }
}
