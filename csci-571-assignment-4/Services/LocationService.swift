//
//  LocationService.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 11/28/23.
//

import Foundation

struct IPInfo: Decodable {
    let postal: String
}

func fetchZipcode(completion: @escaping (String) -> Void) {
        
    let url = URL(string: "https://ipinfo.io/json?token=b28b348d4ab917")!

    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            if let decodedResponse = try? JSONDecoder().decode(IPInfo.self, from: data) {
                DispatchQueue.main.async {
                    completion(decodedResponse.postal)
                }
                return
            }
        }
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
    }.resume()
}
