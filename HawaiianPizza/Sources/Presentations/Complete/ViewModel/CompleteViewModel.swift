//
//  CompleteViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/28/24.
//

import Foundation
import CoreLocation
import WeatherKit

// MARK: - formattedDate: 날짜, weatherCondition: 현재 날씨, highTem: 최고온도, lowTem: 최저, preciptiationChance: 강수확률
// MARK: 위에 녀석들 View에 표출하면 사용자 위치 기반으로 얻을 수 있음.
class CompleteViewModel: ObservableObject {
    @Published var completeRoutine: Routine?
    @Published var symbolName: String = ""
    @Published var dailyWeather: [DayWeather] = []
    @Published var formattedDate: String = ""
    @Published var weatherCondition: String = ""
    @Published var highTemperature: String = ""
    @Published var lowTemperature: String = ""
    @Published var precipitationChance: String = ""
    @Published var currentLocation: CLLocation?
    
    init() {
        addNotiObserver()
        fetchLocation()
        fetchRoutines(selectedRoutineID: nil)
    }
    
    func fetchLocation() {
        if let location = LocationHelper.shared.currentLocation {
            currentLocation = location
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.fetchLocation()
                print("fetchLocation 호출")
            }
        }
    }
    
    func addNotiObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationUpdate), name: .locationUpdate, object: nil)
    }
    
    @objc private func handleLocationUpdate(_ notification: Notification) {
        if let location = notification.userInfo?["location"] as? CLLocation {
            DispatchQueue.main.async {
                self.currentLocation = location
            }
        }
    }
    
    //TODO: 타이머 뷰에서 받은 routine을 심어주고
    //TODO: CheckView에선 SkipTime을 표출해주면 됩니다.
    func fetchRoutines(selectedRoutineID: UUID?) {
        completeRoutine = CoreDataManager.shared.fetchRoutine(by: selectedRoutineID ?? UUID())
    }

    func fetchDailyWeather() async {
        do {
            let daily = try await WeatherHelper.shared.fetchDailyWeather(location: currentLocation ?? CLLocation())
            DispatchQueue.main.async {
                self.dailyWeather = daily.forecast
                self.dateFormatter()
                self.matchingWeatherCase()
                self.temperatureFormatter()
                self.precipitationChanceFormatter()
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
        guard let symbol = dailyWeather.first?.symbolName else { return }
        
        symbolName = symbol
        highTemperature = "최고: \(Int(high.value))도"
        lowTemperature = "최저: \(Int(low.value))도"
    }
    
    func precipitationChanceFormatter() {
        guard let preChance = dailyWeather.first?.precipitationChance else { return }
        let precipitationChancePercent = preChance * 100
        precipitationChance = String(format: "강수 확률: %.0f%%", precipitationChancePercent)
    }
}
