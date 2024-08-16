//
//  AlertManager.swift
//  FireImp
//
//  Created by Ryan Smetana on 12/27/23.
//

import SwiftUI

protocol AlertManager {
    @MainActor var alert: AlertModel? { get set }
    func removeAlert()
//    func pushHaptic(type: HapticPattern)
}
