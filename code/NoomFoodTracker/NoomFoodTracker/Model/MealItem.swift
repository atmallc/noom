//
//  MealItem.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/15/25.
//

import Foundation

// MARK: - Model Layer
struct MealItem: Identifiable, Hashable {
    let id = UUID()
    let foodItem: FoodItem
    let quantity: Int
    let dateAdded: Date
    
    var totalCalories: Int {
        return foodItem.caloriesPerPortion * quantity
    }
    
    var displayText: String {
        let quantityText = quantity > 1 ? "\(quantity)x " : ""
        return "\(quantityText)\(foodItem.displayName)"
    }
}

// MARK: - Meal Summary Model
struct MealSummary {
    let totalCalories: Int
    let totalItems: Int
    let items: [MealItem]
    
    init(items: [MealItem]) {
        self.items = items
        self.totalCalories = items.reduce(0) { $0 + $1.totalCalories }
        self.totalItems = items.reduce(0) { $0 + $1.quantity }
    }
}
