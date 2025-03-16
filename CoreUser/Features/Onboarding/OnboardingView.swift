//
//  OnboardingView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 12/22/23.
//

import SwiftUI
import Speech
import AVFoundation

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

#Preview {
    OnboardingView()
}
