//
//  ItemDetailView.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 11/26/23.
//

import SwiftUI

struct ItemDetailView: View {
    
    let item : Item
    @EnvironmentObject private var wishList: WishList
    @State private var itemDetail : ItemDetail!
    @State private var itemImages = [Imagelinks]()
    @State private var itemSimilar = [SimilarItem]()
    @State private var showProgressView = true
    @State private var isLoading = true
    
    func loadDetailData() {
        showProgressView = true
        fetchItemDetails(itemId: item.itemId[0]) {result in
            self.itemDetail = result.Item
        }
        fetchImageDetails(title: item.title[0]) {result in
            self.itemImages = result.items
        }
        fetchSimilarItems(itemId: item.itemId[0]) {result in
            self.itemSimilar = result.getSimilarItemsResponse.itemRecommendations.item
            showProgressView = false
        }
    }

    var body: some View {
        if self.showProgressView {
            ProgressView()
                .onAppear {
                    loadDetailData()
                }
        } else {
            TabView {
                VStack(alignment: .leading){
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            if let itemDetail = self.itemDetail {
                                ForEach(itemDetail.PictureURL, id: \.self) { imageURL in
                                    AsyncImage(url: URL(string:imageURL)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        //                                        .frame(width: 200, height: 150, alignment: .topLeading)
                                            .containerRelativeFrame(.horizontal)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .padding(.top, -50)
                    Spacer()
                    Text(item.title[0])
                    Spacer()
                    HStack{
                        Text("$"+item.sellingStatus[0].currentPrice[0].__value__)
                            .foregroundColor(Color.blue)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            .bold()
                    }
                    Spacer()
                    HStack{
                        Image(systemName: "magnifyingglass")
                        Text("Description")
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                    Spacer()
                    ScrollView{
                        Grid(alignment: .leading) {
                            if let itemDetail = self.itemDetail {
                                ForEach(itemDetail.ItemSpecifics.NameValueList, id: \.Name) { item in
                                    GridRow{
                                        Rectangle()
                                            .fill(.secondary)
                                            .frame(height: 1)
                                            .gridCellColumns(2)
                                    }
                                    .padding([.bottom], -7)
                                    GridRow{
                                        Text(item.Name)
                                            .lineLimit(1)
                                        Text(item.Value.joined(separator: ", "))
                                            .lineLimit(1)
                                    }
                                    .padding([.bottom], -7)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding([.leading, .trailing], 20)
                .tabItem {
                    VStack {
                        Image(systemName: "info.circle.fill")
                        Text("Info")
                    }
                }
                VStack {
                    if isLoading {
                        ProgressView()
                    } else {
                        Grid {
                            if let itemDetail = self.itemDetail {
                                if self.itemDetail.Storefront != nil || self.itemDetail.Seller.FeedbackScore != nil{
                                    GridRow{
                                        Rectangle()
                                            .fill(.secondary)
                                            .frame(height: 1)
                                            .gridCellColumns(2)
                                    }
                                    GridRow{
                                        HStack{
                                            Image(systemName: "storefront")
                                            Text("Seller")
                                        }
                                        .gridCellAnchor(.leading)
                                    }
                                    GridRow{
                                        Rectangle()
                                            .fill(.secondary)
                                            .frame(height: 1)
                                            .gridCellColumns(2)
                                    }
                                    if !self.itemDetail.Storefront.StoreURL.isEmpty{
                                        GridRow{
                                            Text("Store Name")
                                            Text(self.itemDetail.Storefront.StoreName)
                                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                                .onTapGesture {
                                                    UIApplication.shared.open(URL(string: self.itemDetail.Storefront.StoreURL)!, options: [:])
                                                }
                                        }
                                        .padding(3)
                                    }
                                    if self.itemDetail.Seller.FeedbackScore != 0{
                                        GridRow{
                                            Text("Feedback Score")
                                            Text(String(self.itemDetail.Seller.FeedbackScore))
                                        }
                                        .padding(3)
                                    }
                                    if self.itemDetail.Seller.PositiveFeedbackPercent != 0{
                                        GridRow{
                                            Text("Popularity")
                                            Text(String(self.itemDetail.Seller.PositiveFeedbackPercent))
                                        }
                                        .padding(3)
                                    }
                                }
                                if self.itemDetail.GlobalShipping != nil || self.itemDetail.HandlingTime != nil || !item.shippingInfo[0].shippingServiceCost[0].__value__.isEmpty{
                                    GridRow{
                                        Rectangle()
                                            .fill(.secondary)
                                            .frame(height: 1)
                                            .gridCellColumns(2)
                                    }
                                    GridRow{
                                        HStack{
                                            Image(systemName: "sailboat")
                                            Text("Shipping Info")
                                        }
                                        .gridCellAnchor(.leading)
                                    }
                                    GridRow{
                                        Rectangle()
                                            .fill(.secondary)
                                            .frame(height: 1)
                                            .gridCellColumns(2)
                                    }
                                    if !item.shippingInfo[0].shippingServiceCost[0].__value__.isEmpty{
                                        GridRow{
                                            Text("Shipping Cost")
                                            Text(item.shippingInfo[0].shippingServiceCost[0].__value__ == "0.0" ? "FREE" : item.shippingInfo[0].shippingServiceCost[0].__value__)
                                        }
                                        .padding(3)
                                    }
                                    if self.itemDetail.GlobalShipping != nil{
                                        GridRow{
                                            Text("Global Shipping")
                                            Text(self.itemDetail.GlobalShipping ? "YES" : "NO")
                                        }
                                        .padding(3)
                                    }
                                    if self.itemDetail.HandlingTime != 0{
                                        GridRow{
                                            Text("Handling Time")
                                            Text(String(self.itemDetail.HandlingTime) + " day")
                                        }
                                        .padding(3)
                                    }
                                }
                                if self.itemDetail.ReturnPolicy != nil{
                                    GridRow{
                                        Rectangle()
                                            .fill(.secondary)
                                            .frame(height: 1)
                                            .gridCellColumns(2)
                                    }
                                    GridRow{
                                        HStack{
                                            Image(systemName: "return")
                                            Text("Return Policy")
                                        }
                                        .gridCellAnchor(.leading)
                                    }
                                    GridRow{
                                        Rectangle()
                                            .fill(.secondary)
                                            .frame(height: 1)
                                            .gridCellColumns(2)
                                    }
                                    if !self.itemDetail.ReturnPolicy.ReturnsAccepted.isEmpty{
                                        GridRow{
                                            Text("Policy")
                                            Text(self.itemDetail.ReturnPolicy.ReturnsAccepted)
                                        }
                                        .padding(3)
                                    }
                                    if !self.itemDetail.ReturnPolicy.Refund.isEmpty{
                                        GridRow{
                                            Text("Refund Mode")
                                            Text(self.itemDetail.ReturnPolicy.Refund)
                                                .lineLimit(1)
                                        }
                                        .padding(3)
                                    }
                                    if !self.itemDetail.ReturnPolicy.ReturnsWithin.isEmpty{
                                        GridRow{
                                            Text("Return Within")
                                            Text(self.itemDetail.ReturnPolicy.ReturnsWithin)
                                        }
                                        .padding(3)
                                    }
                                    if !self.itemDetail.ReturnPolicy.ShippingCostPaidBy.isEmpty{
                                        GridRow{
                                            Text("Shipping Cost Paid By")
                                            Text(self.itemDetail.ReturnPolicy.ShippingCostPaidBy)
                                        }
                                        .padding(3)
                                    }
                                }
                            }
                        }
                        .padding([.top, .bottom], 25)
                        Spacer()
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isLoading = false
                    }
                }
                .tabItem {
                    VStack {
                        Image(systemName: "shippingbox.fill")
                        Text("Shipping")
                    }
                }
                PhotoView(itemImages: self.itemImages)
                .tabItem {
                    VStack {
                        Image(systemName: "photo.stack.fill")
                        Text("Photos")
                    }
                }
                SimilarItemView(itemSimilar: self.itemSimilar)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet.indent")
                        Text("Similar")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let shareURL = "https://www.facebook.com/sharer/sharer.php?u=" + self.itemDetail.ViewItemURLForNaturalSearch
                        UIApplication.shared.open(URL(string: shareURL)!)
                    }) {
                        Image(uiImage: #imageLiteral(resourceName: "fb.jpeg"))
                            .resizable()
                            .scaledToFit()
                            .frame(width:20, height:20)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if wishList.wishListItems.contains(where: { $0.itemId == item.itemId }) {
                        Button(action: {
                            removeFromWishlist(product: item) {success in
                                if success {
                                    if let index = wishList.wishListItems.firstIndex(where: { $0.itemId == item.itemId }) { wishList.wishListItems.remove(at: index)
                                    }
                                }
                            }
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Button(action: {
                            addToWishlist(product: item) {success in
                                if success {
                                    wishList.wishListItems.append(item)
                                }
                            }
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(Color.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

//#Preview {
//    ItemDetailView()
//}
