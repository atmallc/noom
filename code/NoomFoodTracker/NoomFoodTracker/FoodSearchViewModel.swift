//
//  FoodSearchViewModel.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/11/25.
//

import Foundation
import SwiftUI

// MARK: - ViewModel Layer
@MainActor
class FoodSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var foodItems: [FoodItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var isSearchBarFocused: Bool = false
    @Published var selectedFoodItem: FoodItem?
    @Published var showFoodDetail: Bool = false
    
    private let networkService = NetworkService.shared
    private let cacheService = CacheService.shared
    private let logger = LoggerService.shared
    private let debounceService = DebounceService(delay: 0.2)
    
    var searchPromptText: String {
        if searchText.isEmpty {
            return "Search for food items..."
        } else if searchText.count < 3 {
            return "Type at least 3 characters"
        } else {
            return ""
        }
    }
    
    var shouldShowPrompt: Bool {
        return searchText.count < 3
    }
    
    init() {
        setupSearchObserver()
    }
    
    private func setupSearchObserver() {
        // Observe search text changes
        $searchText
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.handleSearchTextChange(searchText)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func handleSearchTextChange(_ searchText: String) {
        // Clear previous results if search is too short
        if searchText.count < 3 {
            foodItems = []
            errorMessage = nil
            showError = false
            debounceService.cancel()
            return
        }
        
        // Debounce the search
        debounceService.debounce { [weak self] in
            Task {
                await self?.performSearch(query: searchText)
            }
        }
    }
    
    func performSearch(query: String) async {
        guard query.count >= 3 else { return }
        
        // Check cache first
        if let cachedResults = cacheService.getCachedResults(for: query) {
            logger.log("Using cached results for query: \(query)")
            self.foodItems = cachedResults
            return
        }
        
        // Show loading state
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            logger.log("Searching for: \(query)")
            let results = try await networkService.searchFood(query: query)
            
            // Cache the results
            cacheService.cacheResults(results, for: query)
            
            // Update UI
            self.foodItems = results
            self.isLoading = false
            
            logger.log("Found \(results.count) results for: \(query)")
            
        } catch {
            logger.log("Search error: \(error.localizedDescription)", level: .error)
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            self.showError = true
            self.foodItems = []
        }
    }
    
    func selectFoodItem(_ item: FoodItem) {
        selectedFoodItem = item
        showFoodDetail = true
        logger.log("Selected food item: \(item.name)")
    }
    
    func dismissFoodDetail() {
        showFoodDetail = false
        selectedFoodItem = nil
    }
    
    func retrySearch() {
        showError = false
        Task {
            await performSearch(query: searchText)
        }
    }
    
    func focusSearchBar() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isSearchBarFocused = true
        }
    }
    
    func clearSearch() {
        searchText = ""
        foodItems = []
        errorMessage = nil
        showError = false
    }
}

// MARK: - Import Combine for publishers
import Combine
