//
//  AlertView.swift
//  CoreUser
//
//  Created by Ryan Smetana on 12/31/23.
//

import SwiftUI

struct AlertView: View {
    @State var alert: AlertModel
    @State private var offset: CGFloat = -100
    @State private var opacity: CGFloat = 0
    
    private var lineCount: Int {
        let messageLength = alert.message.count
        switch messageLength {
        case 0...26: return 1
        case 27...52: return 2
        default: return 3
        }
    }
    
    private var alertPadding: CGFloat { CGFloat(8 * lineCount) }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: alert.type.icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                if let title = alert.title {
                    Text(title)
                        .font(.caption)
                }
                
                Text(alert.message)
                    .font(.subheadline)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if alert.dismissible {
                Button {
                    close()
                } label: {
                    Image(systemName: "xmark")
                        .font(.callout)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .foregroundStyle(Color.textLight)
        .frame(maxWidth: 400, maxHeight: 56 + alertPadding)
        .background(
            alert.type.backgroundColor
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 6)
        )
        .padding(.horizontal)
        .padding(.bottom)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height < 0 {
                        close()
                    }
                }
        )
        .offset(y: offset)
        .opacity(opacity)
        .onAppear(perform: alertAppeared)
        .onTapGesture {
            close()
        }
    } //: Body
    
    private func alertAppeared() {
        withAnimation(.bouncy(duration: 0.3, extraBounce: 0.08)) {
            opacity = 1
            offset = 0
        }
    }
    
    private func close() {
        withAnimation(.easeIn(duration: 0.1)) {
            opacity = 0
            offset = -100
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            AlertService.shared.removeCurrentAlert()
        }
    }
}


#Preview {
    AlertView(alert: AlertModel(type: .error, message: "Uh oh! Something went wrong."))
}
