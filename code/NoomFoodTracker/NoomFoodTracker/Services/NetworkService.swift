//
//  NetworkService.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/11/25.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    private let baseURL = "https://uih0b7slze.execute-api.us-east-1.amazonaws.com/dev/search"
    private let session = URLSession.shared
    
    enum NetworkError: Error, LocalizedError {
        case invalidURL
        case noData
        case decodingError
        case serverError(String)
        case queryTooShort
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data received"
            case .decodingError:
                return "Failed to decode response"
            case .serverError(let message):
                return message
            case .queryTooShort:
                return "Search query must be at least 3 characters"
            }
        }
    }
    
    func searchFood(query: String) async throws -> [FoodItem] {
        // Validate query length
        guard query.count >= 3 else {
            throw NetworkError.queryTooShort
        }
        
        // Construct URL with query parameter
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "kv", value: query)]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown server error"
                throw NetworkError.serverError(errorMessage)
            }
            
            // Decode JSON response
            let foodItems = try JSONDecoder().decode([FoodItem].self, from: data)
            return foodItems
            
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.serverError(error.localizedDescription)
        }
    }
}
