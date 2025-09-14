//
//  Components.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/11/25.
//

import SwiftUI

// MARK: - Food Item Row Component
struct FoodItemRow: View {
    let item: FoodItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(item.brand)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("\(item.calories) cal/100g")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text("\(item.portion)g portion")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
