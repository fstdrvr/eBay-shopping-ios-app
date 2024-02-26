//
//  ImageSearchService.swift
//  csci-571-assignment-4
//
//  Created by Benjamin Qian on 12/4/23.
//

import Foundation

struct ImageResult: Decodable {
    let items: [Imagelinks]
}

struct Imagelinks: Decodable {
    let link: String
}

func fetchImageDetails(title: String, completion: @escaping (ImageResult) -> Void) {
    let url = URL(string: "https://kinetic-hydra-176707.wl.r.appspot.com/imagesearch?title=" + title)!
    print(url)
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode(ImageResult.self, from: data)
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
