//
//  SettingsView.swift
//  FireImp
//
//  Created by Ryan Smetana on 3/1/25.
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

struct SettingsView: View {
    @State var vm: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        Form {
            Section("Feedback") {
                Toggle("Sound", isOn: $vm.soundOn)
                Toggle("Haptics", isOn: $vm.hapticsOn)
            } //: Section
            
            Section {
                Button("Reset to Defaults", role: .destructive) {
                    vm.resetToDefaults()
                }
            } //: Section
                        
            Section {
                Button("Test Settings") {
                    if SettingsManager.shared.bool(for: .soundEnabled) {
                        print("Play sound")
                    }
                }
            }
        } //: Form
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
