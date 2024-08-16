//
//  EnvironmentManager.swift
//  FireImp
//
//  Created by Ryan Smetana on 1/4/24.
//

import SwiftUI
import FirebaseAuth

typealias ENV = EnvironmentManager

@MainActor final class EnvironmentManager: ObservableObject, AlertManager {
    @Published var alert: AlertModel?
    @Published var isLoading: Bool = true
    
    @AppStorage("isOnboarding", store: .standard) var isOnboarding: Bool = false
    
    static let shared = EnvironmentManager()
    
    func toggleOnboarding() {
        self.isOnboarding.toggle()
    }
    
    func showAlert(_ type: AlertModel.AlertType, _ message: String) {
        self.alert = AlertModel(type: type, message: message)
    }
    
    nonisolated func removeAlert() {
        Task { @MainActor in
            self.alert = nil
        }
    }
}
