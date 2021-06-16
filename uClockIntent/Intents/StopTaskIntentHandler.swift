//
//  StopTaskIntentHandler.swift
//  uClockIntent
//
//  Created by Eric Walter on 09.02.21.
//

import Intents
import SwiftUI

/// Class to handle the stop intnt
class StopTaskIntentHandler: NSObject, StopTaskIntentHandling {
        
    @AppStorage("timerstorage", store: UserDefaults(suiteName: "group.dev.ericwalter")) var store: Data = Data()
    
    var myTimerData = MyTimerData()
    
    /// Function to handle the intent
    func handle(intent: StopTaskIntent, completion: @escaping (StopTaskIntentResponse) -> Void) {
        
        guard let projectName = intent.projectName, let taskName = intent.taskName
        else {
            completion(StopTaskIntentResponse(code: .failure, userActivity: nil))
            return
        }
        let result = pauseTimer(projectName: projectName, taskName: taskName)
        if result {
            completion(StopTaskIntentResponse.success(projectName: projectName, taskName: taskName))
        } else {
            completion(StopTaskIntentResponse.failure(projectName: projectName, taskName: taskName))
        }
    }
    
    /// Function to pause the timer with matching project and task name
    func pauseTimer(projectName: String, taskName: String) -> Bool {
        
        var result: Bool = false
        let decoder = JSONDecoder()
        
        if let history = try? decoder.decode(MyTimerData.self, from: store){
            myTimerData = history
            var myTimer: MyTimer
            
            /// Search for the timer here: compare given names with all timers from the list
            for item in myTimerData.myTimers {
                if item.projectName == projectName && item.taskName == taskName {
                    myTimer = item
                    result = myTimerData.pauseMyTimer(myTimer: myTimer)
                    break
                } else {
                    result = false
                }
            }
        }
        return result
    }
    
    /// Function to resolve task name
    func resolveTaskName(for intent: StopTaskIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        if let taskName = intent.taskName {
            completion(INStringResolutionResult.success(with: taskName))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    /// Function to resolve project name
    func resolveProjectName(for intent: StopTaskIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        if let projectName = intent.projectName {
            completion(INStringResolutionResult.success(with: projectName))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
}
