//
//  Setting.swift
//  FireImp
//
//  Created by Ryan Smetana on 3/1/25.
//

import Foundation

@propertyWrapper
struct Setting<T> {
    let key: SettingKey
    
    @MainActor
    var wrappedValue: T {
        get {
            switch T.self {
            case is Bool.Type:
                return SettingsManager.shared.bool(for: key) as! T
            default:
                fatalError("Unsupported type for setting")
            }
        }
        set {
            SettingsManager.shared.set(newValue, for: key)
        }
    }
}
