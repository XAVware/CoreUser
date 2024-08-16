//
//  ContentView.swift
//  FireImp
//
//  Created by Ryan Smetana on 2/27/24.
//

import SwiftUI
import Foundation
import FirebaseAuth
import Combine

class RootViewModel: ObservableObject {
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    @Published var currentUser: User?
    
    init() {
        configureSubscribers()
    }
    
    func configureSubscribers() {
        service.$user
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }
}



struct RootView: View {
    @StateObject var vm = RootViewModel()
    @StateObject var uiFeedback = UIFeedbackService.shared
    @State var showLogin: Bool = false
    
    var body: some View {
        ZStack {
            HomeView()
                .onReceive(vm.$currentUser) { user in
                    showLogin = user == nil ? true : false
                }

            
//            if !showLogin && uiFeedback.isLoading {
//                LoadingView()
//            } else if !showLogin && uiFeedback.alert != nil {
//                VStack {
//                    AlertView(alert: uiFeedback.alert!)
//                    Spacer()
//                } //: VStack
//            }
        } //: ZStack
//        .padding()
        .fullScreenCover(isPresented: $showLogin) {
            AuthViewCluster()
                .overlay(uiFeedback.isLoading ? LoadingView() : nil)
                .overlay(uiFeedback.alert != nil ? AlertView(alert: uiFeedback.alert!) : nil, alignment: .top)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
