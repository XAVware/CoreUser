//
//  SettingsViewModel.swift
//  CoreUser
//
//  Created by Ryan Smetana on 3/16/25.
//

import SwiftUI

@MainActor final class SettingsViewModel {
    let settings = SettingsManager.shared
    @Setting(key: .soundEnabled) var soundOn: Bool
    @Setting(key: .hapticEnabled) var hapticsOn: Bool
    
    func resetToDefaults() {
        settings.resetToDefaults()
    }
}
