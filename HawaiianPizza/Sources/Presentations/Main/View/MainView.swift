//
//  MainView.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/24/24.
//

import SwiftUI

struct MainView: View {
  @StateObject private var viewModel = MainViewModel()
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("루틴 설정")
          .font(.title)
          .bold()
        
        Spacer()
      }
      .padding(.top, 27)
      .padding(.bottom, 24)
      
      HStack {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color(UIColor.systemGray4))
          .frame(height: 130)
          .overlay(
            Text("09")
              .font(.system(size: 120, weight: .light))
          )
        
        VStack {
          Text(":")
            .font(.system(size: 120, weight: .light))
            .padding(.bottom)
        }
        .frame(height: 130)
        
        RoundedRectangle(cornerRadius: 20)
          .fill(Color(UIColor.systemGray4))
          .frame(height: 130)
          .overlay(
            Text("30")
              .font(.system(size: 120, weight: .light))
          )
      }
      
      HStack {
        HStack {
          Text("루틴 설정")
            .font(.title)
            .bold()
          
          Spacer()
        }
        
        Button(action: {
          
        }, label: {
          Image(systemName: "plus")
            .resizable()
            .frame(width: 25, height: 25)
            .bold()
            .foregroundStyle(.black)
        })
      }
      .padding(.top, 32)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 0) {
          ForEach(viewModel.items) { item in
            MainRowView(item: item)
              .padding(.trailing, 3)
            
          }
        }
      }
      .padding(.top, 19)
    }
    .padding(.horizontal, 16)
    
    Spacer()
  }
}

#Preview {
  MainView()
}
