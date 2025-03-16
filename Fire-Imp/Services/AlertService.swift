//
//  AlertService.swift
//  AuthApp
//
//  Created by Ryan Smetana on 1/27/25.
//

import SwiftUI

/// Singleton service managing alert queue and display.
/// Features:
/// - Maximum queue size: 10 alerts
/// - Display time range: 2-8 seconds
/// - Priority-based queue management
/// - Automatic dismissal for dismissible alerts
@MainActor
final class AlertService: AlertManaging {
    static let shared = AlertService()
    @Published private(set) var currentAlert: AlertModel?
    var alertPublisher: Published<AlertModel?>.Publisher { $currentAlert }
    
    private var alertQueue: [AlertModel] = []
    private var dismissalTask: Task<Void, Never>?
    
    private enum AlertConfiguration {
        static let maxQueueSize = 10
        static let maxDisplayTime: TimeInterval = 8.0
        static let minDisplayTime: TimeInterval = 2.0
        
        static func validateDuration(_ duration: TimeInterval) -> TimeInterval {
            min(max(duration, minDisplayTime), maxDisplayTime)
        }
    }
    
    private init() {}
    
    func pushAlert(_ alert: AlertModel) {
        if let current = currentAlert {
            handleNewAlert(alert, currentAlert: current)
        } else {
            displayAlert(alert)
        }
    }
    
    func removeCurrentAlert() {
        dismissalTask?.cancel()
        dismissalTask = nil
        currentAlert = nil
        displayNextAlert()
    }
    
    func removeAllAlerts() {
        dismissalTask?.cancel()
        dismissalTask = nil
        currentAlert = nil
        alertQueue.removeAll()
    }
    
    // MARK: - Private Methods
    private func handleNewAlert(_ new: AlertModel, currentAlert current: AlertModel) {
        if new.priority > current.priority {
            alertQueue.insert(current, at: 0)
            displayAlert(new)
        } else {
            if alertQueue.count < AlertConfiguration.maxQueueSize {
                alertQueue.append(new)
            }
        }
    }
    
    private func displayAlert(_ alert: AlertModel) {
        currentAlert = alert
        
        if alert.dismissible {
            scheduleDismissal(for: alert)
        }
    }
    
    private func displayNextAlert() {
        guard let nextAlert = alertQueue.first else { return }
        alertQueue.removeFirst()
        displayAlert(nextAlert)
    }
    
    private func scheduleDismissal(for alert: AlertModel) {
        dismissalTask?.cancel()
        
        let duration = AlertConfiguration.validateDuration(alert.type.duration)
        dismissalTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                if !Task.isCancelled {
                    removeCurrentAlert()
                }
            } catch {
                // Task cancelled, do nothing
            }
        }
    }
}

extension AlertService {
    func pushAlert(
        _ type: AlertType,
        _ message: String,
        title: String? = nil,
        dismissible: Bool = true,
        priority: Int = 0,
        action: (() -> Void)? = nil
    ) {
        let alert = AlertModel(
            type: type,
            message: message,
            title: title,
            dismissible: dismissible,
            priority: priority
        )
        pushAlert(alert)
    }
}
