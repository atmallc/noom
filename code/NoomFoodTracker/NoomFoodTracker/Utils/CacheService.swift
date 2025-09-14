//
//  CacheService.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/11/25.
//

import Foundation

// MARK: - Cache Service
class CacheService {
    static let shared = CacheService()
    private init() {}
    
    private var cache: [String: CacheItem] = [:]
    private let cacheExpirationTime: TimeInterval = 300 // 5 minutes
    
    private struct CacheItem {
        let data: [FoodItem]
        let timestamp: Date
    }
    
    func getCachedResults(for query: String) -> [FoodItem]? {
        guard let cacheItem = cache[query.lowercased()] else { return nil }
        
        // Check if cache has expired
        if Date().timeIntervalSince(cacheItem.timestamp) > cacheExpirationTime {
            cache.removeValue(forKey: query.lowercased())
            return nil
        }
        
        return cacheItem.data
    }
    
    func cacheResults(_ results: [FoodItem], for query: String) {
        let cacheItem = CacheItem(data: results, timestamp: Date())
        cache[query.lowercased()] = cacheItem
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
