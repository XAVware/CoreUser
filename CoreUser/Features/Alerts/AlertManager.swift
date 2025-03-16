//
//  AlertManager.swift
//  CoreUser
//
//  Created by Ryan Smetana on 12/27/23.
//

import SwiftUI

@MainActor
protocol AlertManaging: ObservableObject {
    var currentAlert: AlertModel? { get }
    var alertPublisher: Published<AlertModel?>.Publisher { get }
    
    func pushAlert(_ alert: AlertModel)
    func removeCurrentAlert()
    func removeAllAlerts()
}
