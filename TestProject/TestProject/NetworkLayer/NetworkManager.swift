//
//  NetworkManager.swift
//  TestProject
//
//  Created by Nana Jimsheleishvili on 23.11.23.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager() //Added static keyword
    
    public init() {}
    
    func get<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) { //changed url to urlString just to avoid confusion.
        
        guard let url = URL(string: urlString) else { return } //switched "" with urlString
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            
            guard let data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume() // added resume()
    }
}


