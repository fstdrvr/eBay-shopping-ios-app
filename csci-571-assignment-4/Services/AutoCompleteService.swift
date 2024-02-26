//
//  AutoCompleteService.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 12/2/23.
//

import Foundation

struct postalCodes: Decodable {
    let postalCodes: [postalCode]
}

struct postalCode: Decodable {
    let postalCode: String
}

func searchZipCodes(zipInput: String, completion: @escaping (postalCodes) -> Void) {
    
    let url = URL(string: "https://kinetic-hydra-176707.wl.r.appspot.com/autocomplete?zipInput=" + zipInput)!
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode(postalCodes.self, from: data)
                DispatchQueue.main.async {
                    print(decodedResponse)
                    completion(decodedResponse)
                }
            } catch {
                    print(error)
            }
        } else {
            print("No data")
        }
    }.resume()
}
