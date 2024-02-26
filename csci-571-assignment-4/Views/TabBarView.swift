//
//  SwiftUIView.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 11/21/23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            Text("Info")
                .tabItem {
                    VStack {
                        Image(systemName: "info.circle.fill")
                        Text("Info")
                    }
                }
            Text("Shipping")
                .tabItem {
                    VStack {
                        Image(systemName: "shippingbox.fill")
                        Text("Shipping")
                    }
                }
            Text("Photos")
                .tabItem {
                    VStack {
                        Image(systemName: "photo.stack.fill")
                        Text("Photos")
                    }
                }
            Text("Similar")
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet.indent")
                        Text("Similar")
                    }
                }
        }
    }
}

#Preview {
    TabBarView()
}
