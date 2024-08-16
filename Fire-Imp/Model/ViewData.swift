//
//  ViewData.swift
//  FireImp
//
//  Created by Ryan Smetana on 11/30/23.
//

import SwiftUI

enum ViewPath: Identifiable, Hashable {
    var id: ViewPath { return self }
    case landing
    case login
    case signUp
    case homepage
    case menuView
    case profileView
}
