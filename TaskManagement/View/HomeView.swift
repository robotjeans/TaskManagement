//
//  HomeView.swift
//  TaskManagement
//
//  Created by Shawn Sheehan on 1/30/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                
                Section {
                    
                    // CUrrent Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10) {
                            
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                
                                VStack(spacing: 10) {
                                    
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                // Foreground Style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                // Date Capsule
                                .frame(width: 45, height: 90)
                                .background(
                                    
                                    ZStack {
                                        // Matched Geomtry Effect
                                        if (taskModel.isToday(date: day)) {
                                            
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TasksView()
                } header: {
                    HeaderView()
                    
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // Tasks View
    func TasksView()->some View {
        
        LazyVStack(spacing: 25) {
            
            if let tasks = taskModel.filteredTasks{
                
                if tasks.isEmpty {
                    
                    Text("No Task Found!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                }
                else {
                    
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                }
            }
            else {
                // Progress View
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        // Updating Tasks
        .onChange(of: taskModel.currentDay) { newValue in
            taskModel.filterTodayTasks()
        }
    }
    
    // Task Card View
    func TaskCardView(task: Task)->some View {
        HStack(alignment: .top, spacing: 30) {
            
            VStack(spacing: 10) {
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(taskModel.isCurrentHour(date: task.taskDate) ? 0.8 : 1)
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            VStack() {
                
                HStack(alignment: .top, spacing: 10) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundColor(.black)
                    }
                    .hLeading()
                    
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                    
                }
                
                if taskModel.isCurrentHour(date: task.taskDate) {
                    
                    HStack(spacing: 0) {
                        
                        HStack(spacing: -10) {
                            
                            ForEach(["User1", "User2", "User3"], id:\.self) { user in
                                
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(Circle().stroke(.black, lineWidth: 5))
                            }
                        }
                        .hLeading()
                        
                        // Check Button
                        Button {
                            
                        } label: {
                            
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                                  
                        }
                    }
                    .padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate) ? 0 : 10)
            .hLeading()
            .background(Color("Black").cornerRadius(25).opacity(taskModel.isCurrentHour(date: task.taskDate) ? 1 : 0))
        }
        .hLeading()
    }
    
    // Header
    func HeaderView()->some View {
        
        HStack(spacing: 10) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                if #available(iOS 15.0, *) {
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                        .foregroundColor(.gray)
                } else {
                    // Fallback on earlier versions
                }
                
                Text("Today")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
            }
            .hLeading()
            
            Button {
                
            } label: {
                
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        }
        .padding()
        .padding(.top, taskModel.getSafeArea().top)
        .background(Color.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// UI Helper Functions
extension View {
    
    func hLeading()->some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing()->some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter()->some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
