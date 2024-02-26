//
//  SimilarItemView.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 12/5/23.
//

import SwiftUI

struct SimilarItemView: View {
    let itemSimilar : [SimilarItem]
    @State private var selectedSortOption: SortOption = .defaultSort
    @State private var selectedSortOrder: SortOrder = .ascending
    @State private var isLoading = true
    
    enum SortOption: String, CaseIterable {
        case defaultSort = "Default"
        case name = "Name"
        case price = "Price"
        case daysLeft = "Days Left"
        case shipping = "Shipping"
    }

    enum SortOrder: String, CaseIterable {
        case ascending = "Ascending"
        case descending = "Descending"
    }
    
    var sortedItems: [SimilarItem] {
        var items: [SimilarItem]
        switch selectedSortOption {
        case .defaultSort:
            items = itemSimilar
        case .name:
            items = itemSimilar.sorted(by: { $0.title < $1.title })
        case .price:
            items = itemSimilar.sorted(by: { $0.buyItNowPriceValue < $1.buyItNowPriceValue })
        case .daysLeft:
            items = itemSimilar.sorted(by: { $0.daysLeftValue < $1.daysLeftValue })
        case .shipping:
            items = itemSimilar.sorted(by: { $0.shippingCostValue < $1.shippingCostValue })
        }
        if selectedSortOrder == .descending {
            items.reverse()
        }
        return items
    }
    
    var body: some View {
        VStack{
            if isLoading {
                ProgressView()
            } else {
                HStack{
                    Text("Sort By")
                        .fontWeight(.heavy)
                        .font(.system(size: 22))
                    Spacer()
                }
                .padding([.leading, .trailing], 10)
                Picker("Sort By", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding([.leading, .trailing], 10)
                    .padding(.bottom, 5)
                if selectedSortOption.rawValue != "Default" {
                    HStack{
                        Text("Order")
                            .fontWeight(.heavy)
                            .font(.system(size: 22))
                        Spacer()
                    }
                    .padding([.leading, .trailing], 10)
                    Picker("Order", selection: $selectedSortOrder) {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding([.leading, .trailing], 10)
                        .padding(.bottom, 5)
                }
                
                let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
                ScrollView{
                    LazyVGrid(columns: columns) {
                        ForEach(sortedItems, id: \.itemId) { item in
                            VStack {
                                AsyncImage(url: URL(string: item.imageURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 180, height: 180)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding(.bottom, 20)
                                VStack{
                                    Text(item.title)
                                        .lineLimit(2)
                                        .padding(.bottom, 5)
                                        .font(.system(size: 18))
                                    HStack{
                                        let shippingCost = "$"+item.shippingCost.__value__
                                        let daysLeft = String(item.daysLeftValue) + " days left"
                                        Text(shippingCost)
                                        Spacer()
                                        Text(daysLeft)
                                    }
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                                    HStack{
                                        let buytItNowPrice = "$"+item.buyItNowPrice.__value__
                                        Spacer()
                                        Text(buytItNowPrice)
                                    }
                                    .font(.system(size: 20))
                                    .bold()
                                    .foregroundColor(.blue)
                                    .padding([.top, .bottom], 5)
                                }
                                .padding([.leading, .trailing], 15)
                            }
                            .frame(width: 190, height: 350)
                            .background(RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 2))
                            .background(Color.gray.opacity(0.05))
                            .padding([.top, .bottom], 5)
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
//    SimilarItemView()
//}
