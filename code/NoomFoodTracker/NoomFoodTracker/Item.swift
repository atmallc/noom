//
//  FoodItem.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/11/25.
//

import Foundation

// MARK: - Model Layer
struct FoodItem: Codable, Identifiable, Hashable {
    let id: Int
    let brand: String
    let name: String
    let calories: Int
    let portion: Int
    
    // Computed property for display purposes
    var displayName: String {
        return name
    }
    
    var caloriesPerPortion: Int {
        // Calculate calories per portion based on the portion size
        return (calories * portion) / 100
    }
}
