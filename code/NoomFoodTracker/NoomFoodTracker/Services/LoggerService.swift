//
//  LoggerService.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/14/25.
//

import Foundation

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
