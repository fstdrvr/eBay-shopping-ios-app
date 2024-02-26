//
//  SimilarProductService.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 12/4/23.
//

import Foundation

struct SimilarResult: Decodable {
    let getSimilarItemsResponse: GetSimilarItemsResponse
}

struct GetSimilarItemsResponse: Decodable {
    let itemRecommendations: ItemRecommendations
}

struct ItemRecommendations: Decodable {
    let item: [SimilarItem]
}

struct SimilarItem: Decodable {
    let itemId: String
    let title: String
    let timeLeft: String
    let imageURL: String
    let shippingCost: SimilarPrice
    let buyItNowPrice: SimilarPrice
    
    var buyItNowPriceValue: Double {
        return Double(buyItNowPrice.__value__)!
        }
    
    var shippingCostValue: Double {
        return Double(shippingCost.__value__)!
        }

    var daysLeftValue: Int {
        guard let start = timeLeft.index(timeLeft.startIndex, offsetBy: 1, limitedBy: timeLeft.endIndex),
              let end = timeLeft.firstIndex(of: "D") else {
            return 0
        }
        return Int(timeLeft[start..<end])!
    }
}

struct SimilarPrice: Decodable {
   let __value__: String
}

func fetchSimilarItems(itemId: String, completion: @escaping (SimilarResult) -> Void) {
    let url = URL(string: "https://kinetic-hydra-176707.wl.r.appspot.com/findsimilaritems?itemId=" + itemId)!
    print(url)
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode(SimilarResult.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
            } catch {
                print(error)
                return
            }
        } else {
            print("No data")
            return
        }
    }.resume()
}

