//
//  CompleteViewModel.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/28/24.
//

import Foundation
import CoreLocation
import WeatherKit
import SwiftUI

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
    @Published var tasks: [Tasks] = []
    @AppStorage("selectedRoutine") var selectedRoutineID: String?

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

    func fetchRoutines(selectedRoutineID: UUID?) {
        completeRoutine = CoreDataManager.shared.fetchRoutine(by: selectedRoutineID ?? UUID())
        if let routine = completeRoutine {
            tasks = routine.tasks?.array as? [Tasks] ?? []
            var skipTime: Int32 = 0

            tasks.forEach { task in
                let taskSkipTime = task.taskSkipTime
                let taskTime = task.taskTime
                skipTime += (taskTime * 60) - taskSkipTime
                print("잡자1",task.taskSkipTime)
                print("잡자2",task.taskTime * 60)
                print("잡자3",skipTime)
            }

            routine.totalSkipTime = skipTime
            completeRoutine = routine // @Published 속성을 통해 업데이트
            CoreDataManager.shared.saveContext()

            print("Total Skip Time: \(skipTime)")
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
        highTemperature = "최고 : \(Int(high.value))도"
        lowTemperature = "최저 : \(Int(low.value))도"
    }

    func precipitationChanceFormatter() {
        guard let preChance = dailyWeather.first?.precipitationChance else { return }
        let precipitationChancePercent = preChance * 100
        precipitationChance = String(format: "강수 확률 : %.0f%%", precipitationChancePercent)
    }
  
    func deleteRoutineID() {
        UserDefaults.standard.removeObject(forKey: "selectedRoutine")
        UserDefaults.standard.removeObject(forKey: "isNotificationSet")
    }
}
