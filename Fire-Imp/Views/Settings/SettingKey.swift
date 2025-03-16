//
//  SettingKey.swift
//  FireImp
//
//  Created by Ryan Smetana on 3/1/25.
//

import Foundation

enum SettingKey: String, CaseIterable {
    case soundEnabled
    case hapticEnabled
    
    var defaultValue: Any {
        switch self {
        case .soundEnabled:     return true
        case .hapticEnabled:    return true
        }
    }
}
