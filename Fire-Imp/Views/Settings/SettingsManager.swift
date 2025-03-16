//
//  SettingsManager.swift
//  FireImp
//
//  Created by Ryan Smetana on 3/1/25.
//

import SwiftUI

@MainActor
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    private let defaults = UserDefaults.standard
    private let settingsKey = "com.fireimp.settings"
    
    @Published private var settings: [String: Any] = [:]
    
    private init() {
        loadSettings()
    }
    
    func bool(for key: SettingKey) -> Bool {
        settings[key.rawValue] as? Bool ?? key.defaultValue as! Bool
    }
    
    func set(_ value: Any, for key: SettingKey) {
        settings[key.rawValue] = value
        saveSettings()
        objectWillChange.send()
    }
    
    func resetToDefaults() {
        settings.removeAll()
        SettingKey.allCases.forEach { key in
            settings[key.rawValue] = key.defaultValue
        }
        saveSettings()
        objectWillChange.send()
    }
        
    private func loadSettings() {
        if let savedSettings = defaults.dictionary(forKey: settingsKey) {
            settings = savedSettings
        } else {
            resetToDefaults()
        }
    }
    
    private func saveSettings() {
        defaults.set(settings, forKey: settingsKey)
    }
}
