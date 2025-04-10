//
//  APIManager.swift
//  Flickr
//
//  Created by Ajay Kunte on 10/04/25.
//

import Foundation

// MARK: APIEndpoint
struct APIConstants {
    static let defaultQuery = "nature"
    static let baseURL = "https://api.pexels.com"
}

enum APIEndpoint {
    // Endpoint Type
    case search(query: String, page: Int, perPage: Int)

    // EndPoint URL
    var url: URL? {
        switch self {
        case .search(let query, let page, let perPage):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            let urlString = "\(APIConstants.baseURL)/v1/search?query=\(encodedQuery)&per_page=\(perPage)&page=\(page)"
            return URL(string: urlString)
        }
    }
}

// MARK: APIEndpoint
class APIManager {
    static let shared = APIManager()
    private let apiKey = "YoIF4ajO8E4bWNcHrgEG02NlHA1aKyQ4m5WPSsxpeNetyXZbT93aPqzx"

    func fetchImages(query: String = APIConstants.defaultQuery, page: Int, perPage: Int = 15, completion: @escaping ([PexelsPhoto]) -> Void) {
        guard let url = APIEndpoint.search(query: query, page: page, perPage: perPage).url else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decoded = try JSONDecoder().decode(PexelsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.photos)
                }
            } catch {
                print("Decoding Error: \(error)")
            }
        }.resume()
    }
}
