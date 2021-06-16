//
//  MyTimerStore.swift
//  uClock
//
//  Created by Eric Walter on 03.02.21.
//

import Foundation
import SwiftUI

/// The timer store handles the encoding and decoding of the timer data
struct MyTimerStore {
    
    @AppStorage("timerstorage", store: UserDefaults(suiteName: "group.dev.ericwalter")) var store: Data = Data()
    
    var myTimers: [MyTimer] = []
    
    /// Load timer array when initialized
    init() {
        
        myTimers = getMyTimers()
    }
    
    /// Function to get an array of MyTimer objects
    func getMyTimers() -> [MyTimer] {
        
        var recentTimers: [MyTimer] = []
        let decoder = JSONDecoder()
        
        if let history = try? decoder.decode(MyTimerData.self, from: store) {
            recentTimers = history.myTimers
        }
        
        return recentTimers
    }
    
    /// Function to update the MyTimerData object
    func update(myTimerData: MyTimerData) -> Bool {
        
        var result = true
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(myTimerData) {
            store = data
        } else {
            result = false
        }
        
        return result
    }
}
