//
//  WishListService.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 12/2/23.
//

import Foundation

class WishList: ObservableObject {
    @Published var wishListItems = [Item]()
}

func loadWishListData(wishList: WishList) {
   fetchWishListItems() { wishListItem in
       wishList.wishListItems = wishListItem
   }
}


func fetchWishListItems(completion: @escaping ([Item]) -> Void) {
    
    let url = URL(string: "https://kinetic-hydra-176707.wl.r.appspot.com/wishlist-fetech")!
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode([Item].self, from: data)
                DispatchQueue.main.async {
                    print(decodedResponse)
                    completion(decodedResponse)
                }
            } catch {
//                print("Failed to decode JSON")
            }
        } else {
            print("No data")
        }
    }.resume()
}

func addToWishlist(product: Item, completion:@escaping (Bool) -> ()) {
    let url = URL(string: "https://kinetic-hydra-176707.wl.r.appspot.com/wishlist-operate?action=add&product=" + String(describing: product))!
    let request = URLRequest(url: url)

    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            DispatchQueue.main.async {
                completion(false)
            }
        } else if let data = data {
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    .resume()
}

func removeFromWishlist(product: Item, completion:@escaping (Bool) -> ()) {
    let url = URL(string: "https://kinetic-hydra-176707.wl.r.appspot.com/wishlist-operate?action=remove&product=" + String(describing: product))!
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            DispatchQueue.main.async {
                completion(false)
            }
        } else if let data = data {
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    .resume()
}


