//
//  FoodSearchView.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/11/25.
//

import SwiftUI

// MARK: - View Layer
struct FoodSearchView: View {
    @StateObject private var viewModel = FoodSearchViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Header with logo and search bar
                    headerSection(geometry: geometry)
                    
                    // Content area
                    contentSection
                    
                    Spacer()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .onTapGesture {
                // Tap anywhere to focus search bar and animate it to top
                if !viewModel.isSearchBarFocused {
                    viewModel.focusSearchBar()
                    isSearchFieldFocused = true
                }
            }
        }
        .sheet(isPresented: $viewModel.showFoodDetail) {
            if let selectedItem = viewModel.selectedFoodItem {
                FoodDetailView(foodItem: selectedItem) {
                    viewModel.dismissFoodDetail()
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("Retry") {
                viewModel.retrySearch()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
    }
    
    @ViewBuilder
    private func headerSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            if !viewModel.isSearchBarFocused {
                // Welcome state - logo in center
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "fork.knife.circle")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("NoomFoodTracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Discover nutritional information")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            } else {
                // Search state - compact header
                HStack {
                    Image(systemName: "fork.knife.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text("NoomFoodTracker")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            
            // Search bar
            searchBarSection
        }
        .frame(height: viewModel.isSearchBarFocused ? 120 : geometry.size.height * 0.7)
        .animation(.easeInOut(duration: 0.25), value: viewModel.isSearchBarFocused)
    }
    
    @ViewBuilder
    private var searchBarSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search for food items...", text: $viewModel.searchText)
                    .focused($isSearchFieldFocused)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit {
                        Task {
                            await viewModel.performSearch(query: viewModel.searchText)
                        }
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: viewModel.clearSearch) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            // Search prompt text
            if viewModel.shouldShowPrompt && !viewModel.searchPromptText.isEmpty {
                Text(viewModel.searchPromptText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal)
        .onChange(of: isSearchFieldFocused) { _, focused in
            if focused && !viewModel.isSearchBarFocused {
                viewModel.focusSearchBar()
            }
        }
    }
    
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isSearchBarFocused {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    loadingView
                } else if !viewModel.foodItems.isEmpty {
                    foodListView
                } else if !viewModel.searchText.isEmpty && viewModel.searchText.count >= 3 {
                    emptyStateView
                }
            }
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Searching...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var foodListView: some View {
        List(viewModel.foodItems) { item in
            FoodItemRow(item: item) {
                viewModel.selectFoodItem(item)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No results found")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Try searching for a different food item")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}


#Preview {
    FoodSearchView()
}
