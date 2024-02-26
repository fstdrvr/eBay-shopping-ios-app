//
//  SearchFormView.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 11/21/23.
//

import SwiftUI

struct SearchFormView: View {
    
    @StateObject var searchParams = SearchParameterModel()
    @StateObject var wishList = WishList()
    @State private var isResultsVisible = false
    @State private var items = [Item]()
    @State private var zipCodes : [postalCode] = []
    @State private var showToast = false
    @State private var toastError = ""
    @State private var showProgressView = false
    @State private var isLoading = false
    @State private var showSheet = false
    @State private var navigateToWishList = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var textFieldInput: String = ""

        
    func loadProductData(url: URL) {
      showProgressView = true
      fetchItems(url: url) {result in
          guard !result.findItemsAdvancedResponse.isEmpty else {
              self.items = []
              showProgressView = false
              return
          }
          self.items = result.findItemsAdvancedResponse[0].searchResult[0].item
          showProgressView = false
      }
    }
   
    func loadAutoCompleteData(zipInput: String) {
        searchZipCodes(zipInput: zipInput) { result in
            self.zipCodes = result.postalCodes
        }
        self.showSheet = true
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    Form {
                        Section {
                            HStack {
                                Text("Keyword:")
                                TextField("Required", text: $searchParams.keyword)
                            }
                            Picker("Category", selection: $searchParams.category, content: {
                                Text("All").tag(0)
                                Text("Art").tag(550)
                                Text("Baby").tag(2984)
                                Text("Books").tag(267)
                                Text("Clothing, Shoes & Accessories").tag(11450)
                                Text("Computers/Tablets & Networking").tag(58058)
                                Text("Health & Beauty").tag(26395)
                                Text("Music").tag(11233)
                                Text("Video Games & Consoles").tag(1249)
                            })
                            .pickerStyle(.menu)
                            VStack {
                                HStack{
                                    Text("Condition" )
                                    Spacer()
                                }
                                HStack{
                                    Spacer()
                                    CheckBoxView(checked: $searchParams.isUsed)
                                    Text("Used")
                                    Spacer()
                                    CheckBoxView(checked: $searchParams.isNew)
                                    Text("New")
                                    Spacer()
                                    CheckBoxView(checked: $searchParams.isUnspecified)
                                    Text("Unspecified")
                                    Spacer()
                                }
                                .padding(.all, 5.0)
                            }
                            VStack {
                                HStack{
                                    Text("Shipping" )
                                    Spacer()
                                }
                                HStack{
                                    Spacer()
                                    CheckBoxView(checked: $searchParams.pickupOnly)
                                    Text("Pickup")
                                    Spacer()
                                    CheckBoxView(checked: $searchParams.freeShipping)
                                    Text("Free Shipping")
                                    Spacer()
                                }
                                .padding(.all, 5.0)
                            }
                            HStack {
                                Text("Distance:" )
                                TextField("10", text: $searchParams.distance)
                            }
                            HStack {
                                Toggle("Custom Location", isOn: $searchParams.selectCustomZip)
                            }
                            if searchParams.selectCustomZip {
                                HStack {
                                    Text("Zipcode:" )
                                    TextField("Required", text: $textFieldInput)
                                       .focused($isTextFieldFocused)
                                       .onAppear {
                                           isTextFieldFocused = true
                                       }
                                       .onSubmit {
                                           searchParams.customZip = textFieldInput
                                           loadAutoCompleteData(zipInput: textFieldInput)
                                           isLoading = true
                                       }
                                }
                                .sheet(isPresented: Binding(
                                    get: { self.showSheet },
                                    set: { newValue in
                                        if newValue {
                                            self.showSheet = true
                                        } else {
                                            self.showSheet = false
                                        }
                                    }
                                )) {
                                    VStack{
                                        if isLoading {
                                            ProgressView()
                                        } else {
                                            HStack{
                                                Text("Pincode Suggestions")
                                                    .font(.title)
                                                    .fontWeight(.heavy)
                                                    .padding()
                                            }
                                            Form {
                                                ForEach(self.zipCodes, id: \.postalCode) { zipCode in
                                                    Button(action: {
                                                        searchParams.customZip = zipCode.postalCode
                                                        textFieldInput = zipCode.postalCode
                                                        self.showSheet = false
                                                    }) {
                                                        HStack {
                                                            Text(zipCode.postalCode)
                                                            Spacer()
                                                        }
                                                        .foregroundColor(.black)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            self.isLoading = false
                                        }
                                    }
                                }
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    if searchParams.keyword.trimmingCharacters(in: .whitespaces).isEmpty {
                                        toastError = "Keyword is mandatory"
                                        withAnimation {
                                            showToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation {
                                                showToast = false
                                            }
                                        }
                                    } else if searchParams.selectCustomZip {
                                        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: searchParams.customZip)) || searchParams.customZip.count != 5 {
                                            toastError = "Zip is mandatory"
                                            withAnimation {
                                                showToast = true
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                withAnimation {
                                                    showToast = false
                                                }
                                            }
                                        } else {
                                            print(searchParams.constructURL() ?? "")
                                            isResultsVisible = true
                                            loadProductData(url: searchParams.constructURL()!)
                                        }
                                    } else {
                                        print(searchParams.constructURL() ?? "")
                                        isResultsVisible = true
                                        loadProductData(url: searchParams.constructURL()!)
                                    }
                                }, label: {
                                    Text("Submit")
                                        .frame(width: 110, height: 50, alignment: .center)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                })
                                .buttonStyle(BorderlessButtonStyle())
                                Spacer()
                                Button(action: {
                                    searchParams.reset()
                                    isResultsVisible = false
                                    self.items = [Item]()
                                }, label: {
                                    Text("Clear")
                                        .frame(width: 110, height: 50, alignment: .center)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                })
                                .buttonStyle(BorderlessButtonStyle())
                                Spacer()
                            }
                        }
                        if isResultsVisible {
                            Section {
                                HStack {
                                    Text("Results").font(.title).fontWeight(.bold).padding(.vertical, 5.0)
                                    Spacer()
                                }
                                if showProgressView {
                                    HStack{
                                        Spacer()
                                        ProgressView("Please wait...")
                                            .id(Date())
                                        Spacer()
                                    }
                                } else {
                                    if self.items.isEmpty {
                                        HStack{
                                            Text("No results found.")
                                                .foregroundColor(.red)
                                            Spacer()
                                        }
                                    }
                                }
                                List(items, id: \.itemId) { item in
                                    NavigationLink(destination: ItemDetailView(item: item)) {
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
                                            if wishList.wishListItems.contains(where: { $0.itemId == item.itemId }) {
                                                Button(action: {
                                                    removeFromWishlist(product: item) {success in
                                                        if success {
                                                            if let index = wishList.wishListItems.firstIndex(where: { $0.itemId == item.itemId }) { wishList.wishListItems.remove(at: index)
                                                            }
                                                        }
                                                    }
                                                    toastError = "Removed from Wishlist"
                                                    withAnimation {
                                                        showToast = true
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                        withAnimation {
                                                            showToast = false
                                                        }
                                                    }
                                                }) {
                                                    Image(systemName: "heart.fill")
                                                        .foregroundColor(Color.red)
                                                        .font(.system(size: 25))
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            } else {
                                                Button(action: {
                                                    addToWishlist(product: item) {success in
                                                        if success {
                                                            wishList.wishListItems.append(item)
                                                        }
                                                    }
                                                    toastError = "Added to Wishlist"
                                                    withAnimation {
                                                        showToast = true
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                        withAnimation {
                                                            showToast = false
                                                        }
                                                    }
                                                }) {
                                                    Image(systemName: "heart")
                                                        .foregroundColor(Color.red)
                                                        .font(.system(size: 25))
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .toolbar {
                       NavigationLink(destination: WishListView(), isActive: $navigateToWishList) {
                           Button {
                               navigateToWishList = true
                           } label: {
                               Image(systemName: "heart.circle")
                           }
                           .buttonStyle(PlainButtonStyle())
                       }
                    }
                }
                .navigationTitle("Produdct Search")
                if showToast {
                    VStack {
                        Spacer()
                        ToastView(errorMessage: toastError)
                            .padding()
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.1))
                    }
                }
                
            }
        }
        .onAppear {
            fetchZipcode {zipCode in
                searchParams.zip = zipCode
            }
            loadWishListData(wishList: wishList)
        }
        .environmentObject(wishList)
    }
}

#Preview {
    SearchFormView()
}
