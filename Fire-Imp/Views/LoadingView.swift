//
//  LoadingView.swift
//  FireImp
//
//  Created by Ryan Smetana on 1/2/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("Loading...")
//                .font(.custom("Marker Felt", size: 24))
//                .foregroundStyle(K.primaryColor)
            
            ProgressView()
                .scaleEffect(1.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bg)
    }
}

#Preview {
    LoadingView()
}
