//
//  AlertModel.swift
//  FireImp
//
//  Created by Ryan Smetana on 12/29/23.
//

import SwiftUI

struct AlertModel: Identifiable, Equatable {
    let id: UUID = UUID()
    let type: AlertType
    let title: String?
    let message: String
    let dismissible: Bool
    let priority: Int
    
    init(type: AlertType,
         message: String,
         title: String? = nil,
         dismissible: Bool = true,
         priority: Int = 0) {
        self.type = type
        self.message = message
        self.title = title
        self.dismissible = dismissible
        self.priority = priority
    }
}
