//
//  DynamicLiveActivity.swift
//  Dynamic
//
//  Created by Pil_Gaaang on 7/31/24.
//
import ActivityKit
import WidgetKit
import SwiftUI

struct DynamicLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicAttributes.self) { context in
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("남은 시간")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        HStack {
                            Text(String(format: "%02d", Int(context.state.remainingTime) / 60))
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            Text(":")
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            Text(String(format: "%02d", Int(context.state.remainingTime) % 60))
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.92, green: 0.93, blue: 0.91))
                            .frame(width: 60, height: 60)
                        Image(systemName: context.state.iconName)  // 아이콘 이름 사용
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black) // 아이콘 색상을 검정색으로 설정
                    }
                }
                .padding()
                .background(Color.black)
                .cornerRadius(10) // 모서리 반경 설정
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                ProgressBar(progress: CGFloat(context.state.remainingTime) / CGFloat(60))
                    .frame(height: 10)
                    .padding(.top, -5)
            }
            .padding()
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text("남은 시간")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        HStack {
                            Text(String(format: "%02d", Int(context.state.remainingTime) / 60))
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            Text(":")
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            Text(String(format: "%02d", Int(context.state.remainingTime) % 60))
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.92, green: 0.93, blue: 0.91))
                            .frame(width: 60, height: 60)
                        Image(systemName: context.state.iconName)  // 아이콘 이름 사용
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black) // 아이콘 색상을 검정색으로 설정
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressBar(progress: CGFloat(context.state.remainingTime) / CGFloat(60))
                        .frame(height: 10)
                        .padding(.top, -5)
                }
            } compactLeading: {
                Text("남은 시간")
                    .foregroundColor(.white)
            } compactTrailing: {
                Text(String(format: "%02d:%02d", Int(context.state.remainingTime) / 60, Int(context.state.remainingTime) % 60))
                    .foregroundColor(.white)
            } minimal: {
                Text("타이머")
                    .foregroundColor(.white)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 전체 바의 배경
                Rectangle()
                    .fill(Color(red: 0.92, green: 0.93, blue: 0.91))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // 남은 시간에 따른 프로그레스
                Rectangle()
                    .fill(Color.red)
                    .frame(width: geometry.size.width * progress, height: geometry.size.height)
                    .animation(.linear(duration: 1), value: progress)
            }
            .cornerRadius(2)
        }
    }
}
