//
//  NavPath.swift
//  FireImp
//
//  Created by Ryan Smetana on 11/30/23.
//

import SwiftUI

enum NavPath: Identifiable, Hashable {
    var id: NavPath { return self }
    case landing
    case login
    case signUp
    case homepage
    case menuView
    case profileView
    case settings
}
