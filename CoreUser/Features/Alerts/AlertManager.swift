//
//  AlertManager.swift
//  CoreUser
//
//  Created by Ryan Smetana on 12/27/23.
//

import SwiftUI


/// TaskManager --
/// If the view that is overlaying the alert is presented in a sheet, `.ignoresSafeArea(.all)` needs to be added to the AlertView, like this:
///
/// `.overlay(taskFeedbackService.alert != nil ? AlertView(alert: taskFeedbackService.alert!).ignoresSafeArea(.all) : nil, alignment: .top)`
///
/// Otherwise, if the view is presented in a FullScreenCover, the overlay should be the following:
///
///`.overlay(taskFeedbackService.alert != nil ? AlertView(alert: taskFeedbackService.alert!).ignoresSafeArea(.all) : nil, alignment: .top)`
///


@MainActor
protocol AlertManaging: ObservableObject {
    var currentAlert: AlertModel? { get }
    var alertPublisher: Published<AlertModel?>.Publisher { get }
    
    func pushAlert(_ alert: AlertModel)
    func removeCurrentAlert()
    func removeAllAlerts()
}
