//
//  FoodDetailView.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/11/25.
//

import SwiftUI

// MARK: - Food Detail View
struct FoodDetailView: View {
    let foodItem: FoodItem
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text(foodItem.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(foodItem.brand)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Nutrition Info
                VStack(spacing: 16) {
                    nutritionRow(title: "Calories per 100g", value: "\(foodItem.calories)")
                    nutritionRow(title: "Portion Size", value: "\(foodItem.portion)g")
                    nutritionRow(title: "Calories per Portion", value: "\(foodItem.caloriesPerPortion)")
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Food Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") { onDismiss() })
        }
    }
    
    @ViewBuilder
    private func nutritionRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
    }
}
