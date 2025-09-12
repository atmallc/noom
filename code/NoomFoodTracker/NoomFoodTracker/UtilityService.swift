//
//  UtilityService.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/11/25.
//

import Foundation

// MARK: - Utility Layer

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

// MARK: - Debounce Service
class DebounceService {
    private var workItem: DispatchWorkItem?
    private let delay: TimeInterval
    
    init(delay: TimeInterval = 0.2) { // 200ms as specified
        self.delay = delay
    }
    
    func debounce(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
    
    func cancel() {
        workItem?.cancel()
    }
}

// MARK: - Logger Service
class LoggerService {
    static let shared = LoggerService()
    private init() {}
    
    enum LogLevel {
        case info, warning, error
        
        var prefix: String {
            switch self {
            case .info: return "ℹ️ INFO"
            case .warning: return "⚠️ WARNING"
            case .error: return "❌ ERROR"
            }
        }
    }
    
    func log(_ message: String, level: LogLevel = .info) {
        let timestamp = DateFormatter.logFormatter.string(from: Date())
        print("[\(timestamp)] \(level.prefix): \(message)")
    }
}

// MARK: - Extensions
extension DateFormatter {
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
