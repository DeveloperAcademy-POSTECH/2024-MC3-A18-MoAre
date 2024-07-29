import SwiftUI
import CoreLocation

struct CompleteView: View {
    @StateObject private var viewModel = CompleteViewModel()
    @State private var showProgressView = false
    
    var body: some View {
        VStack {
            if !showProgressView {
                CheckView()
                    .task {
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
        return VStack {
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
                Text("예상보다 \(viewModel.completeRoutine?.totalSkipTime ?? 0)분이 줄었네요")
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
                Text(viewModel.formattedDate)
                    .font(.system(size: 32, weight: .bold))
                
                Circle()
                    .fill(.gray)
                    .frame(width: 178, height: 178)
                    .overlay {
                        Image(systemName: "\(viewModel.dailyWeather[0].symbolName)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }
                    .padding()
                VStack {
                    Text("현재온도")
                    Text(viewModel.weatherCondition)
                    Text(viewModel.highTemperature)
                    Text(viewModel.lowTemperature)
                }
                .font(.system(size: 17, weight: .semibold))
            }
        }
    }
}

#Preview {
    CompleteView()
}
