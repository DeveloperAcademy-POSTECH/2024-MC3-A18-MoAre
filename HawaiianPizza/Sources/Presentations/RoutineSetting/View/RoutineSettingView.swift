//
//  RoutineSettingView.swift
//  HawaiianPizza
//
//  Created by 유지수 on 7/26/24.
//

import SwiftUI

struct RoutineSettingView: View {
  @State var routineTitle: String = ""
  @StateObject private var viewModel = RoutineSettingViewModel()
  @State private var editMode: EditMode = .active
  @State var showSheet: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("루틴 설정")
          .font(.title)
          .bold()
          .padding(.leading, 16)
        
        Spacer()
      }
      .padding(.top, 27)
      
      TextField("루틴명", text: $routineTitle)
        .font(.system(.title3).bold())
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
      // padding 수정 가능
        .padding(.top, 16)
        .padding(.horizontal, 20)
      
      HStack {
        Text("루틴 관리")
          .font(.system(.headline).bold())
          .foregroundStyle(.gray)
          .padding(.top, 22)
          .padding(.leading, 24)
        
        Spacer()
      }
      
      ZStack {
        Color.white.ignoresSafeArea()
        
        // MARK: - 루틴 관리 List
        NavigationView {
          List {
            Button(action: {
              showSheet.toggle()
            }, label: {
              HStack {
                Spacer()
                Image(systemName: "plus.rectangle")
                  .resizable()
                  .frame(width: 37, height: 25)
                  .foregroundStyle(Color(UIColor.systemGray4))
                Spacer()
              }
            })
            .padding()
            .listRowBackground(
              Color(UIColor.secondarySystemBackground)
                .cornerRadius(10)
                .padding(.vertical, 8)
            )
            .sheet(isPresented: $showSheet) {
              AddTaskView()
                .presentationDetents([
                  .fraction(0.4)
                ])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(20)
            }
            
            ForEach(viewModel.items) { item in
              RoutineSettingRowView(item: item, onDelete: {
                viewModel.delete(item: item)
              })
              .listRowSeparator(.hidden)
              .listRowBackground(
                Color(UIColor.secondarySystemBackground)
                  .cornerRadius(10)
                  .padding(.vertical, 8)
              )
            }
            .onMove(perform: viewModel.move)
          }
          .listStyle(.inset)
          .environment(\.editMode, $editMode)
          .onAppear {
            self.editMode = .active
          }
        }
      }
      .padding(.horizontal, 16)
      
      Spacer()
      
      Button(action: {
        
      }, label: {
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .frame(height: 50)
            .foregroundStyle(Color(UIColor.systemGray))
          
          Text("다음 단계")
            .font(.title2)
            .foregroundStyle(.black)
            .bold()
        }
        .padding(.horizontal, 20)
      })
    }
  }
}

#Preview {
  RoutineSettingView()
}
