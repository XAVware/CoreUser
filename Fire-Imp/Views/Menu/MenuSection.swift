//
//  MenuSection.swift
//  FireImp
//
//  Created by Ryan Smetana on 1/29/25.
//

import Foundation

struct MenuSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [MenuItem]
}
