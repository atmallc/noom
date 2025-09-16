//
//  MealTrackingViewModel.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/15/25.
//

import Foundation
import SwiftUI
import Combine

// MARK: - ViewModel Layer
@MainActor
class MealTrackingViewModel: ObservableObject {
    @Published var mealItems: [MealItem] = []
    @Published var mealSummary: MealSummary = MealSummary(items: [])
    @Published var showMealView: Bool = false
    
    private let logger = LoggerService.shared
    
    init() {
        updateMealSummary()
    }
    
    // MARK: - Public Methods
    func addFoodItem(_ foodItem: FoodItem) {
        // Check if this food item already exists in the meal
        if let existingIndex = mealItems.firstIndex(where: { $0.foodItem.id == foodItem.id }) {
            // Increment quantity of existing item
            let existingItem = mealItems[existingIndex]
            let updatedItem = MealItem(
                foodItem: existingItem.foodItem,
                quantity: existingItem.quantity + 1,
                dateAdded: existingItem.dateAdded
            )
            mealItems[existingIndex] = updatedItem
            logger.log("Incremented quantity for \(foodItem.name) to \(updatedItem.quantity)")
        } else {
            // Add new item with quantity 1
            let newMealItem = MealItem(
                foodItem: foodItem,
                quantity: 1,
                dateAdded: Date()
            )
            mealItems.append(newMealItem)
            logger.log("Added new food item to meal: \(foodItem.name)")
        }
        
        updateMealSummary()
    }
    
    func removeFoodItem(_ mealItem: MealItem) {
        if let index = mealItems.firstIndex(where: { $0.id == mealItem.id }) {
            let removedItem = mealItems.remove(at: index)
            logger.log("Removed food item from meal: \(removedItem.foodItem.name)")
            updateMealSummary()
        }
    }
    
    func decrementQuantity(_ mealItem: MealItem) {
        if let index = mealItems.firstIndex(where: { $0.id == mealItem.id }) {
            let currentItem = mealItems[index]
            
            if currentItem.quantity > 1 {
                // Decrement quantity
                let updatedItem = MealItem(
                    foodItem: currentItem.foodItem,
                    quantity: currentItem.quantity - 1,
                    dateAdded: currentItem.dateAdded
                )
                mealItems[index] = updatedItem
                logger.log("Decremented quantity for \(currentItem.foodItem.name) to \(updatedItem.quantity)")
            } else {
                // Remove item if quantity would become 0
                removeFoodItem(mealItem)
            }
            
            updateMealSummary()
        }
    }
    
    func incrementQuantity(_ mealItem: MealItem) {
        if let index = mealItems.firstIndex(where: { $0.id == mealItem.id }) {
            let currentItem = mealItems[index]
            let updatedItem = MealItem(
                foodItem: currentItem.foodItem,
                quantity: currentItem.quantity + 1,
                dateAdded: currentItem.dateAdded
            )
            mealItems[index] = updatedItem
            logger.log("Incremented quantity for \(currentItem.foodItem.name) to \(updatedItem.quantity)")
            updateMealSummary()
        }
    }
    
    func clearMeal() {
        mealItems.removeAll()
        logger.log("Cleared all items from meal")
        updateMealSummary()
    }
    
    func showMealTrackingView() {
        showMealView = true
    }
    
    func hideMealTrackingView() {
        showMealView = false
    }
    
    // MARK: - Private Methods
    private func updateMealSummary() {
        mealSummary = MealSummary(items: mealItems)
    }
    
    // MARK: - Computed Properties
    var hasMealItems: Bool {
        return !mealItems.isEmpty
    }
    
    var mealItemsCount: Int {
        return mealSummary.totalItems
    }
    
    var totalCalories: Int {
        return mealSummary.totalCalories
    }
}
