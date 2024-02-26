//
//  WishListView.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 12/3/23.
//

import SwiftUI


struct WishListView: View {
    
    @EnvironmentObject private var wishList: WishList
    @State private var wishListTotal = 0.0
    
    func calculateItemTotal() {
        let totalValue = wishList.wishListItems.reduce(0) {total, item in
            let itemValue = Double(item.sellingStatus[0].currentPrice[0].__value__)
            return total + itemValue!
        }
        self.wishListTotal = totalValue
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    if wishList.wishListItems.isEmpty {
                        Spacer()
                        HStack{
                            Spacer()
                            Text("No items in wishlist")
                            Spacer()
                        }
                        Spacer()
                    } else {
                        Form {
                            Section {
                                HStack{
                                    Text("Wishlist total(\(wishList.wishListItems.count)) items:")
                                    Spacer()
                                    Text("$\(self.wishListTotal, specifier:"%.2f")")
                                }
                                List(wishList.wishListItems, id: \.itemId) { item in
                                    HStack {
                                        AsyncImage(url: URL(string:item.galleryURL[0])) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .padding(.all, 10.0)
                                        .frame(width: 75, height: 75)
                                        VStack {
                                            HStack {
                                                Text(item.title[0]).lineLimit(1)
                                                Spacer()
                                            }
                                            .padding(.vertical, 1.0)
                                            HStack {
                                                Text("$"+item.sellingStatus[0].currentPrice[0].__value__)
                                                Spacer()
                                            }
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.blue)
                                            .padding(.vertical, 1.0)
                                            HStack {
                                                Text(item.shippingInfo[0].shippingServiceCost[0].__value__ == "0.0" ? "FREE SHIPPING" : "$" + item.shippingInfo[0].shippingServiceCost[0].__value__)
                                                Spacer()
                                            }
                                            .foregroundColor(Color.gray)
                                            .padding(.vertical, 1.0)
                                            HStack {
                                                Text(item.postalCode[0])
                                                Spacer()
                                                switch item.condition[0].conditionId[0] {
                                                case "1000":
                                                    Text("NEW")
                                                case "2000", "2500":
                                                    Text("REFURBISHED")
                                                case "3000", "4000", "5000", "6000":
                                                    Text("USED")
                                                default:
                                                    Text("NA")
                                                }
                                            }
                                            .foregroundColor(Color.gray)
                                            .padding(.vertical, 1.0)
                                        }
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            wishList.wishListItems.removeAll(where: { $0.itemId == item.itemId })
                                            calculateItemTotal()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Favorites")
            }
        }
        .onAppear {
            loadWishListData(wishList: wishList)
            calculateItemTotal()
        }
    }
}
        
#Preview {
    WishListView()
}
