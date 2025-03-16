//
//  MenuItem.swift
//  FireImp
//
//  Created by Ryan Smetana on 1/29/25.
//

import Foundation

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: NavPath?
}

extension MenuItem: Hashable {
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
