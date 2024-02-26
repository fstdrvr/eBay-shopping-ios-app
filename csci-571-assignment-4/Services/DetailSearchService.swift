//
//  DetailSearchService.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 12/3/23.
//

import Foundation

struct DetailResult: Decodable {
    let Item: ItemDetail
}

struct ItemDetail: Decodable {
    let PictureURL: [String]
    let Storefront: Storefront
    let Seller: Seller
    let Title: String
    let ItemSpecifics: ItemSpecifics
    let GlobalShipping: Bool
    let HandlingTime: Int
    let ReturnPolicy: ReturnPolicy
    let ViewItemURLForNaturalSearch: String
}

struct Storefront: Decodable{
    let StoreName: String
    let StoreURL: String
}

struct Seller: Decodable {
    let UserID: String
    let FeedbackRatingStar: String
    let FeedbackScore: Int
    let PositiveFeedbackPercent: Double
}

struct ReturnPolicy: Codable {
   let Refund: String
   let ReturnsWithin: String
   let ReturnsAccepted: String
   let ShippingCostPaidBy: String
}

struct ItemSpecifics: Decodable {
    let NameValueList: [NameValue]
}

struct NameValue: Decodable {
    let Name: String
    let Value: [String]
}

func fetchItemDetails(itemId: String, completion: @escaping (DetailResult) -> Void) {
    let url = URL(string: "https://kinetic-hydra-176707.wl.r.appspot.com/findsingleitem?itemId=" + itemId)!
    print(url)
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode(DetailResult.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
            } catch {
//                print("Can not parse JSON")
//                return
            }
        } else {
            print("No data")
            return
        }
    }.resume()
}
