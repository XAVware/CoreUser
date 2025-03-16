//
//  OnboardingView.swift
//  FireImp
//
//  Created by Ryan Smetana on 12/22/23.
//

import SwiftUI
import Speech
import AVFoundation

@MainActor class OnboardingViewModel: ObservableObject {
    enum ViewState { case microphone, pushNotifications }
    @Published var currentState: ViewState = .microphone
    
    var title: String {
        return switch self.currentState {
        case .microphone: "Microphone"
        case .pushNotifications: "Push Notifications"
        }
    }
    
    var description: String {
        return switch currentState {
        case .microphone: "Please allow microphone access"
        case .pushNotifications: "Please allow push notifications."
        }
    }
    
    var imageUrl: String {
        return switch currentState {
        case .microphone: "AccessVoice"
        case .pushNotifications: "website"
        }
    }
    
    func incrementPage() {
        switch currentState {
        case .microphone:
            currentState = .pushNotifications
        case .pushNotifications:
            finish()
        }
    }
    
    func finish() {
        UserManager.shared.finishOnboarding()
    }
    
    func nextTapped() {
        switch currentState {
        case .microphone:
            incrementPage()
        case .pushNotifications:
            // Request push notification access
            finish()
        }
    }
}

struct OnboardingView: View {
    @StateObject var vm: OnboardingViewModel = OnboardingViewModel()
        
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 32) {
                Text(vm.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(vm.imageUrl)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                
                Text(vm.description)
                    .font(.callout)
                    .multilineTextAlignment(.center)
            } //: VStack
            .padding(.top)
            
            Spacer()
            
            Button {
                vm.nextTapped()
            } label: {
                Text("Request Access")
                    .frame(maxWidth: .infinity)
            }
            .modifier(PrimaryButtonMod())
            .padding()
            
            Button {
                vm.incrementPage()
            } label: {
                Text("Not Now")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)
            
        } //: VStack
        .padding()
        .background(.bg)
    } //: Body
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
