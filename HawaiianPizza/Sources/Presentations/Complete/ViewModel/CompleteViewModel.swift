//
//  CompleteViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/28/24.
//

import Foundation
import CoreLocation
import WeatherKit

class CompleteViewModel: ObservableObject {
    @Published var completeRoutine: Routine?
    @Published var dailyWeather: [DayWeather] = []
    @Published var formattedDate: String = ""
    @Published var weatherCondition: String = ""
    @Published var highTemperature: String = ""
    @Published var lowTemperature: String = ""
    @Published var currentLocation: CLLocation?
    
    init() {
        LocationHelper.shared.checkLocationAuthorization()
        fetchLocation()
        fetchRoutines(selectedRoutineID: nil)
    }
    
    func fetchLocation() {
        if let location = LocationHelper.shared.currentLocation {
            currentLocation = location
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.fetchLocation()
            }
        }
    }
    
    @objc private func handleLocationUpdate(_ notification: Notification) {
        if let location = notification.userInfo?["location"] as? CLLocation {
            DispatchQueue.main.async {
                self.currentLocation = location
            }
        }
    }
    
    // 이게 차후에 Routine 타이머가 다 돌아가고 나서 선택된 루틴의 ID와 같은지 확인하고 같을 때 completeRoutine으로 할당
    // completeRoutine을 View에 바인딩해서 completeRoutine.totalSkipTime을 표출
    func fetchRoutines(selectedRoutineID: UUID?) {
        let routines = CoreDataManager.shared.fetchAllRoutines()
        completeRoutine = routines.first
        //        completeRoutine = routines.first(where: { $0.id == selectedRoutineID })
    }

    func fetchDailyWeather() async {
        do {
            let daily = try await WeatherHelper.shared.fetchDailyWeather(location: currentLocation ?? CLLocation())
            DispatchQueue.main.async {
                self.dailyWeather = daily.forecast
                self.dateFormatter()
                self.matchingWeatherCase()
                self.temperatureFormatter()
            }
            for day in daily {
                print("날씨 \(day.condition)")
                print("최고 기온 \(day.highTemperature)")
                print("최저 기온 \(day.lowTemperature)")
                print("비: \(day.precipitation)")
                print("강수량 \(day.precipitationAmount)")
                print("강수 확률 \(day.precipitationChance)")
            }
        } catch {
            print("Failed to fetch weather: \(error)")
        }
    }
    
    func dateFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일"
        let date = formatter.string(from: Date())
        formattedDate = date
    }
    
    func matchingWeatherCase() {
        guard let condition = dailyWeather.first?.condition else { return }
        
        switch condition {
        case .clear, .mostlyClear, .sunShowers, .sunFlurries:
            weatherCondition = "맑음"
        case .partlyCloudy, .cloudy, .mostlyCloudy, .haze, .smoky, .blowingDust, .foggy:
            weatherCondition = "흐림"
        case .drizzle, .rain, .freezingDrizzle, .freezingRain, .heavyRain, .isolatedThunderstorms, .scatteredThunderstorms, .thunderstorms, .tropicalStorm, .strongStorms, .hurricane:
            weatherCondition = "비"
        case .flurries, .snow, .blizzard, .blowingSnow, .heavySnow, .sleet, .wintryMix:
            weatherCondition = "눈"
        default:
            weatherCondition = "알 수 없음"
        }
    }
    
    func temperatureFormatter() {
        guard let high = dailyWeather.first?.highTemperature else { return }
        guard let low = dailyWeather.first?.lowTemperature else { return }
        
        highTemperature = "최고: \(Int(high.value))도"
        lowTemperature = "최저: \(Int(low.value))도"
    }
}
