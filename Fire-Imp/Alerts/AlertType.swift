//
//  AlertType.swift
//  FireImp
//
//  Created by Ryan Smetana on 1/29/25.
//

import SwiftUI

// Visual behavior of alerts for each type
enum AlertType {
    case error
    case success
    case warning
    case info
    
    var duration: TimeInterval {
        switch self {
        case .error: 5.0
        case .success: 3.0
        case .warning: 4.0
        case .info: 3.0
        }
    }
    
    var icon: String {
        switch self {
        case .error: "exclamationmark.triangle.fill"
        case .success: "checkmark"
        case .warning: "exclamationmark.triangle"
        case .info: "info.circle"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .error: .red
        case .success: .green
        case .warning: .yellow
        case .info: .blue
        }
    }
}
