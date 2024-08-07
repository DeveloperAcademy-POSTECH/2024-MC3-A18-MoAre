import SwiftUI
import CoreLocation

// MARK: - 변경되는 UI에 맞게 수정해야 하니 요소정도만 표출 해놨습니다.

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
                
                Image(systemName: "\(viewModel.symbolName)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 178)
                    .padding()
                
                Text("오늘의 날씨")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.bottom, 19)
              
                VStack {
                    Text(viewModel.weatherCondition)
                    Text("최고 : \(viewModel.highTemperature)도 / 최저 : \(viewModel.lowTemperature)도")
                    Text("강수 확률 : \(viewModel.precipitationChance)%")
                }
                .font(.system(size: 18, weight: .semibold))
                  
                Button(action: {
                  // MARK: - 메인 화면으로 이동
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

#Preview {
    CompleteView()
}
