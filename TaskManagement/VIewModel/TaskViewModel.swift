//
//  TaskViewModel.swift
//  TaskManagement
//
//  Created by Shawn Sheehan on 1/30/22.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    // Mock Tasks
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "Family Dinner", taskDescription: "Delicious dinner tonight", taskDate:
                .init(timeIntervalSince1970: 1643558404)),
        
        Task(taskTitle: "Meeting", taskDescription: "Discuss team targets and goals", taskDate:
                    .init(timeIntervalSince1970: 1643664981)),
        Task(taskTitle: "UI Team", taskDescription: "Go over UI updates", taskDate:
                    .init(timeIntervalSince1970: 1643669121)),
        Task(taskTitle: "Prototype", taskDescription: "Explore prototypes", taskDate:
                    .init(timeIntervalSince1970: 1643634021)),
        Task(taskTitle: "Lunch Break", taskDescription: "Grab Pho at Ho Chi", taskDate:
                    .init(timeIntervalSince1970: 1643752821)),
        Task(taskTitle: "Management Meeting", taskDescription: "Discuss year end goals with client", taskDate:
                    .init(timeIntervalSince1970: 1643752897)),
        Task(taskTitle: "HR", taskDescription: "File documents with HR", taskDate:
                    .init(timeIntervalSince1970: 1643651897)),
        Task(taskTitle: "Close Day", taskDescription: "Go over and daily issues with team", taskDate:
                    .init(timeIntervalSince1970: 1643757897)),
        Task(taskTitle: "Team Party", taskDescription: "Meet up with dev team for beers", taskDate:
                    .init(timeIntervalSince1970: 1643751497))
    ]
    
    // Current Weekdays
    @Published var currentWeek: [Date] = []
    
    // Current Day
    @Published var currentDay: Date = Date()
    
    // Filter Task By Day
    @Published var filteredTasks: [Task]?
    
    // Initialize
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    // Filter Today Tasks
    func filterTodayTasks() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.taskDate < task1.taskDate
                }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
    }
    
    func fetchCurrentWeek() {
        
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    // Extract Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // Check If Current Date = Today
    func isToday(date: Date) -> Bool {
        
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // Safe Area
    func getSafeArea()->UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
    
    // Match Current Hour To Task Hour
    func isCurrentHour(date: Date)->Bool {
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
