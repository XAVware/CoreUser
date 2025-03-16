//
//  OnboardingViewModel.swift
//  CoreUser
//
//  Created by Ryan Smetana on 3/16/25.
//

import SwiftUI

@MainActor class OnboardingViewModel: ObservableObject {
    enum ViewState { case microphone, pushNotifications }
    @Published var currentState: ViewState = .microphone
    
    var title: String {
        return switch self.currentState {
        case .microphone: "Microphone"
        case .pushNotifications: "Push Notifications"
        }
    }
    
    var description: String {
        return switch currentState {
        case .microphone: "Please allow microphone access"
        case .pushNotifications: "Please allow push notifications."
        }
    }
    
    var imageUrl: String {
        return switch currentState {
        case .microphone: "AccessVoice"
        case .pushNotifications: "website"
        }
    }
    
    func incrementPage() {
        switch currentState {
        case .microphone:
            currentState = .pushNotifications
        case .pushNotifications:
            finish()
        }
    }
    
    func finish() {
        UserManager.shared.finishOnboarding()
    }
    
    func nextTapped() {
        switch currentState {
        case .microphone:
            incrementPage()
        case .pushNotifications:
            // Request push notification access
            finish()
        }
    }
}
