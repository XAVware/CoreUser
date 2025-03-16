//
//  AuthView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 2/27/24.
//

import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    enum AuthState { case loginEmail, signUpEmail, forgotPassword }
    @Published private(set) var currentState: AuthState = .loginEmail
    private let authService: AuthService
    private let alertService: AlertService
    private let taskManager: TaskManager
    
    init(authService: AuthService? = nil, 
         alertService: AlertService? = nil, 
         taskManager: TaskManager? = nil) {
        self.authService = authService ?? AuthService.shared
        self.alertService = alertService ?? AlertService.shared
        self.taskManager = taskManager ?? TaskManager.shared
    }
    
    /// Handle the primary action from any of the authentication views
    /// 
    /// - Parameters:
    ///   - email: The user's email
    ///   - passwordSet: The user's password passed in a Set. When creating an account, both the password and confirm password should be passed - if the passwords don't match the set will have more than 1 object.
    func continueTapped(email: String, passwordSet: Set<String> = []) async {
        taskManager.isLoading = true
        defer { taskManager.isLoading = false }
        
        guard passwordSet.count <= 1 else {
            alertService.pushAlert(AlertModel(type: .error, message: "Passwords do not match"))
            return
        }
        
        do {
            switch currentState {
            case .loginEmail:
                guard let password = passwordSet.first else { return }
                try await login(withEmail: email, password: password)
                
            case .signUpEmail:
                guard let password = passwordSet.first else { return }
                try await createUser(withEmail: email, password: password)
                
            case .forgotPassword:
                try await sendResetPasswordEmail(to: email)
            }
        } catch let error as AppError {
            alertService.pushAlert(.error, error.localizedDescription)
        } catch {
            alertService.pushAlert(.error, "Unknown: \(error)")
        }
    }
    
    func changeState(to newState: AuthState) {
        guard newState != currentState else { return }
        currentState = newState
    }
    
    private func createUser(withEmail email: String, password: String) async throws {
        try await authService.createUser(email: email, password: password)
    }
    
    private func login(withEmail email: String, password: String) async throws {
        try await authService.login(withEmail: email, password: password)
    }
     
    private func sendResetPasswordEmail(to email: String) async throws {
        try await authService.sendResetPasswordLink(toEmail: email)
    }
}

struct AuthView: View {
    @StateObject var vm = AuthViewModel()
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
    AuthView()
}
