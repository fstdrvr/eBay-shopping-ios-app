//
//  SeachParameterModel.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 11/24/23.
//

import Foundation

class SearchParameterModel: ObservableObject {
    @Published var keyword = ""
    @Published var category = 0
    @Published var isUsed = false
    @Published var isNew = false
    @Published var isUnspecified = false
    @Published var pickupOnly = false
    @Published var freeShipping = false
    @Published var distance = ""
    @Published var selectCustomZip = false
    @Published var customZip = ""
    @Published var zip = ""
    
    func reset() {
        self.keyword = ""
        self.category = 0
        self.isUsed = false
        self.isNew = false
        self.isUnspecified = false
        self.pickupOnly = false
        self.freeShipping = false
        self.distance = ""
        self.selectCustomZip = false
        self.customZip = ""
    }
    
    func constructURL() -> URL? {
        var components = URLComponents()
        var conditions = [String]()
        var shipping = [String]()
        
        components.scheme = "https"
        components.host = "kinetic-hydra-176707.wl.r.appspot.com"
        components.path = "/finditems"
        
        if self.isUsed {
            conditions.append("Used")
        }
        if self.isNew {
            conditions.append("New")
        }
        if self.isUnspecified {
            conditions.append("Unspecified")
        }
        let conditionValue = conditions.joined(separator: ",")
        
        if self.freeShipping {
            shipping.append("freeShipping")
        }
        if self.pickupOnly {
            shipping.append("localPickup")
        }
        let shippingValue = shipping.joined(separator: ",")
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "keywords", value: self.keyword))
        queryItems.append(URLQueryItem(name: "categoryId", value: String(self.category)))
        queryItems.append(URLQueryItem(name: "condition", value: conditionValue))
        queryItems.append(URLQueryItem(name: "shipping", value: shippingValue))
        queryItems.append(URLQueryItem(name: "distance", value: self.distance == "" ? "10" : self.distance))
        queryItems.append(URLQueryItem(name: "zip", value: self.selectCustomZip ? self.customZip : self.zip))
        
        components.queryItems = queryItems
        
        return components.url
    }
}
