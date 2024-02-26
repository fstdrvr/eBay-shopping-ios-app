//
//  ToastView.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 11/28/23.
//

import SwiftUI

struct ToastView: View {
    var errorMessage: String
    
    var body: some View {
            Text(errorMessage)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
    }
}

//#Preview {
//    ToastView()
//}
