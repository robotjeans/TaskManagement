//
//  Task.swift
//  TaskManagement
//
//  Created by Shawn Sheehan on 1/30/22.
//

import SwiftUI

// Task Model
struct Task: Identifiable{
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
