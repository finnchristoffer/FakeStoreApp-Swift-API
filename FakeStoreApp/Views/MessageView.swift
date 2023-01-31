//
//  MessageView.swift
//  FakeStoreApp
//
//  Created by Finn Christoffer Kurniawan on 31/01/23.
//

import SwiftUI


enum MessageType {
    case success
    case warning
    case error
}

struct MessageView: View {
    
    let title: String
    let message: String
    let messageType: MessageType
    
    private var backgroundColor: Color {
        switch messageType {
        case .success:
            return Color.green
        case .warning:
            return Color.orange
        case .error:
            return Color.red
        }
    }
    
    var body: some View {
        VStack {
            Text(title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(message)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(.white)
        .padding()
        .background {
            backgroundColor
        }
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .padding()
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(title: "Error", message: "Unable to load product. Please check productId", messageType: .error)
    }
}
