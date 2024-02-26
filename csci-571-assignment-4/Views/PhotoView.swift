//
//  PhotoView.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 12/5/23.
//

import SwiftUI

struct PhotoView: View {
    
    let itemImages : [Imagelinks]
    @State private var isLoading = true

    var body: some View {
        VStack{
            if isLoading {
                ProgressView()
            } else {
                HStack{
                    Spacer()
                    Text("Powered by")
                        .bold()
                    Image(uiImage: #imageLiteral(resourceName: "google.png"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, alignment: .trailing)
                    Spacer()
                }
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                        ForEach(self.itemImages, id: \.link) { imageURL in
                            AsyncImage(url: URL(string:imageURL.link)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: .infinity, alignment: .topLeading)
                                //                                    .containerRelativeFrame(.horizontal)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoading = false
            }
        }
    }
}

//#Preview {
//    PhotoView()
//}
