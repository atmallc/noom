//
//  MealTrackingView.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/15/25.
//

import SwiftUI

// MARK: - View Layer
struct MealTrackingView: View {
    @ObservedObject var viewModel: MealTrackingViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with total calories
                mealSummaryHeader
                
                // Meal items list
                if viewModel.hasMealItems {
                    mealItemsList
                } else {
                    emptyMealView
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Meal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                if viewModel.hasMealItems {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear All") {
                            viewModel.clearMeal()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var mealSummaryHeader: some View {
        VStack(spacing: 16) {
            // Calories display
            VStack(spacing: 8) {
                Text("\(viewModel.totalCalories)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Total Calories")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            // Items count
            if viewModel.hasMealItems {
                HStack(spacing: 4) {
                    Image(systemName: "fork.knife")
                        .foregroundColor(.blue)
                    
                    Text("\(viewModel.mealItemsCount) item\(viewModel.mealItemsCount == 1 ? "" : "s")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    @ViewBuilder
    private var mealItemsList: some View {
        List {
            ForEach(viewModel.mealItems) { mealItem in
                MealItemRow(
                    mealItem: mealItem,
                    onIncrement: { viewModel.incrementQuantity(mealItem) },
                    onDecrement: { viewModel.decrementQuantity(mealItem) },
                    onRemove: { viewModel.removeFoodItem(mealItem) }
                )
            }
        }
        .listStyle(PlainListStyle())
        .padding(.top, 16)
    }
    
    @ViewBuilder
    private var emptyMealView: some View {
        VStack(spacing: 24) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No items in your meal")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Search for food items and tap to add them to your meal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Meal Item Row Component
struct MealItemRow: View {
    let mealItem: MealItem
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Food info
            VStack(alignment: .leading, spacing: 4) {
                Text(mealItem.foodItem.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !mealItem.foodItem.brand.isEmpty {
                    Text(mealItem.foodItem.brand)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("\(mealItem.foodItem.caloriesPerPortion) cal per portion")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            // Quantity controls
            HStack(spacing: 12) {
                // Quantity display and controls
                VStack(spacing: 4) {
                    HStack(spacing: 8) {
                        Button(action: onDecrement) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title3)
                                .foregroundColor(.red)
                        }
                        
                        Text("\(mealItem.quantity)")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(minWidth: 30)
                        
                        Button(action: onIncrement) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                    }
                    
                    Text("\(mealItem.totalCalories) cal")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                
                // Remove button
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundColor(.red)
                }
                .padding(.leading, 8)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    let viewModel = MealTrackingViewModel()
    
    // Add some sample data for preview
    let sampleFood1 = FoodItem(id: 1, brand: "Generic", name: "Apple", calories: 52, portion: 100)
    let sampleFood2 = FoodItem(id: 2, brand: "Brand", name: "Banana", calories: 89, portion: 100)
    
    viewModel.addFoodItem(sampleFood1)
    viewModel.addFoodItem(sampleFood2)
    viewModel.addFoodItem(sampleFood1) // Add apple again to test quantity
    
    return MealTrackingView(viewModel: viewModel)
}
