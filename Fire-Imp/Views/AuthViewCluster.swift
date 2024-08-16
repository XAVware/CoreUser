//
//  AuthViewCluster.swift
//  FireImp
//
//  Created by Ryan Smetana on 2/27/24.
//

import SwiftUI

class AuthViewClusterModel: ObservableObject {
    enum AuthState { case loginEmail, signUpEmail, forgotPassword }
    @Published var currentState: AuthState = .loginEmail
    
    func createUser(withEmail email: String, password: String) async throws {
        await UIFeedbackService.shared.startLoading()
        try await AuthService.shared.createUser(email: email, password: password)
    }
    
    func login(withEmail email: String, password: String) async throws {
        await UIFeedbackService.shared.startLoading()
        try await AuthService.shared.login(withEmail: email, password: password)
    }
     
    func sendResetPasswordEmail(to email: String) async throws {
        await UIFeedbackService.shared.startLoading()
        try await AuthService.shared.sendResetPasswordLink(toEmail: email)
    }
}

/// UIFeedbackService --
/// If the view that is overlaying the alert is presented in a sheet, `.ignoresSafeArea(.all)` needs to be added to the AlertView, like this:
///
/// `.overlay(taskFeedbackService.alert != nil ? AlertView(alert: taskFeedbackService.alert!).ignoresSafeArea(.all) : nil, alignment: .top)`
///
/// Otherwise, if the view is presented in a FullScreenCover, the overlay should be the following:
///
///`.overlay(taskFeedbackService.alert != nil ? AlertView(alert: taskFeedbackService.alert!).ignoresSafeArea(.all) : nil, alignment: .top)`
///

struct AuthViewCluster: View {
    @StateObject var vm = AuthViewClusterModel()
    @State private var email = ""
    
    var body: some View {
        NavigationStack {
            switch vm.currentState {
            case .loginEmail:       LoginView(email: $email)
            case .signUpEmail:      SignUpView(email: $email)
            case .forgotPassword:   ResetPasswordView(email: $email)
            }
        }
        .background(.bg)
        .environmentObject(vm)
    }

}

#Preview {
    AuthViewCluster()
}
