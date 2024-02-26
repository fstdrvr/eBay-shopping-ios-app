//
//  ProductSearchService.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 11/27/23.
//

import Foundation

struct SearchResult: Decodable {
    let findItemsAdvancedResponse: [FindItemsAdvancedResponse]
}

struct FindItemsAdvancedResponse: Decodable {
    let searchResult: [SearchResultItem]
}

struct SearchResultItem: Decodable {
    let item: [Item]
}

struct Item: Decodable, Observable {
    let itemId: [String]
    let galleryURL: [String]
    let title: [String]
    let sellingStatus: [CurrentPrice]
    let shippingInfo: [ShippingServiceCost]
    let postalCode: [String]
    let condition: [ConditionId]
}

struct CurrentPrice: Decodable {
    let currentPrice: [Price]
}

struct ShippingServiceCost: Decodable {
    let shippingServiceCost: [Price]
}

struct ConditionId: Decodable {
    let conditionId: [String]
}

struct Price: Decodable {
    let __value__: String
}

func fetchItems(url: URL, completion: @escaping (SearchResult) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode(SearchResult.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
            } catch {
                print("Failed to decode JSON")
                completion(SearchResult(findItemsAdvancedResponse: []))
            }
        } else {
            print("No data")
            completion(SearchResult(findItemsAdvancedResponse: []))
        }
    }.resume()
}
