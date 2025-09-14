//
//  DebounceService.swift
//  NoomFoodTracker
//
//  Created by Varun Goyal on 9/14/25.
//

import Foundation

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
