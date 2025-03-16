//
//  TaskFeedbackService.swift
//  CoreUser
//
//  Created by Ryan Smetana on 3/13/24.
//

import SwiftUI

@MainActor 
class TaskManager: ObservableObject {
    @Published var isLoading: Bool = false
    
    static let shared = TaskManager()
    
    func startLoading() {
        Task { @MainActor in
            self.isLoading = true
        }
    }
    
    func stopLoading() {
        self.isLoading = false
    }
}
