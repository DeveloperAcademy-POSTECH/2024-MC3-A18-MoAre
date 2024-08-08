import SwiftUI
import CoreLocation

protocol CompleteViewDelegate: AnyObject {
  func didCompleteRoutine()
}

struct CompleteView: View {
  weak var delegate: CompleteViewDelegate?
  @StateObject private var viewModel = CompleteViewModel()
  @EnvironmentObject var coordinator: Coordinator
  @EnvironmentObject var localNotificationManager: LocalNotificationManager
  @State private var showProgressView = false
  let routineID: UUID?
  
  var body: some View {
    VStack {
      if !showProgressView {
        CheckView()
          .task {
            viewModel.fetchRoutines(selectedRoutineID: routineID)
            await viewModel.fetchDailyWeather()
          }
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              showProgressView = true
            }
          }
      } else {
        WeatherView()
      }
    }
  }
}

extension CompleteView {
  //MARK: Lottie Check View
  func CheckView() -> some View {
    VStack {
      LottieView(loopMode: .playOnce, jsonName: "complete")
        .frame(width: 178, height: 178)
        .padding(.bottom, 50)
      
      if viewModel.completeRoutine?.totalSkipTime == 0 {
        VStack {
          Text("루틴을 잘 마무리하셨네요.")
          Text("오늘 날씨를 알아볼까요?")
        }
        .font(.system(size: 17, weight: .semibold))
      } else {
        Text("예상보다 \((Double(viewModel.completeRoutine?.totalSkipTime ?? 0)/60)) 초가 줄었네요!")
          .font(.system(size: 17, weight: .semibold))
      }
    }
  }
  
  //MARK: Weather View
  @ViewBuilder
  func WeatherView() -> some View {
    if viewModel.dailyWeather.isEmpty {
      ProgressView()
        .progressViewStyle(.circular)
    } else {
      VStack {
        Spacer()
        
        Text(viewModel.formattedDate)
          .font(.system(size: 32, weight: .bold))
        
        Image(systemName: "\(viewModel.symbolName)")
          .resizable()
          .scaledToFit()
          .frame(width: 100)
          .padding()
        
        Text("오늘의 날씨")
          .font(.system(size: 20, weight: .semibold))
          .padding(.bottom, 19)
        
        VStack {
          Text(viewModel.weatherCondition)
            .padding(.bottom, 5)
          Text("\(viewModel.highTemperature) / \(viewModel.lowTemperature)")
            .padding(.bottom, 5)
          Text(viewModel.precipitationChance)
        }
        .font(.system(size: 18, weight: .semibold))
        
        Spacer()
        
        Button(action: {
          viewModel.deleteRoutineID()
          localNotificationManager.navigateToView = false
          coordinator.push(destination: .main)
        }, label: {
          RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(red: 1, green: 0.39, blue: 0.29))
            .frame(height: 48)
            .overlay(
              Text("완료")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
            )
        })
        .padding(.horizontal, 16)
        
      }
    }
  }
}
