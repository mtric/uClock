//
//  StartTaskIntent.swift
//  uClockIntent
//
//  Created by Eric Walter on 09.02.21.
//

import Intents
import SwiftUI

/// Class for handling the start intent
class StartTaskIntentHandler: NSObject, TrackTaskIntentHandling {
        
    @AppStorage("timerstorage", store: UserDefaults(suiteName: "group.dev.ericwalter")) var store: Data = Data()
    
    var myTimerData = MyTimerData()
    
    /// Function to handle the intent
    func handle(intent: TrackTaskIntent, completion: @escaping (TrackTaskIntentResponse) -> Void) {
        
        guard let projectName = intent.projectName, let taskName = intent.taskName
        else {
            completion(TrackTaskIntentResponse(code: .failure, userActivity: nil))
            return
        }
        let result = startTimer(projectName: projectName, taskName: taskName)
        if result {
            completion(TrackTaskIntentResponse.success(projectName: projectName, taskName: taskName))
        } else {
            completion(TrackTaskIntentResponse.failure(projectName: projectName, taskName: taskName))
        }
    }
    
    /// Function to start the timer with matching project and task name
    func startTimer(projectName: String, taskName: String) -> Bool {
        
        var result: Bool = false
        let decoder = JSONDecoder()
        
        if let history = try? decoder.decode(MyTimerData.self, from: store){
            myTimerData = history
            var myTimer: MyTimer
            
            /// Search for the timer here: compare given names with all timers from the list
            for item in myTimerData.myTimers {
                if item.projectName == projectName && item.taskName == taskName {
                    myTimer = item
                    result = myTimerData.startMyTimer(myTimer: myTimer)
                    break
                } else {
                    result = false
                }
            }
        }
        return result
    }
    
    /// Function to resolve the task name
    func resolveTaskName(for intent: TrackTaskIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        if let taskName = intent.taskName {
            completion(INStringResolutionResult.success(with: taskName))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    /// Function to resolve the project Name
    func resolveProjectName(for intent: TrackTaskIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        if let projectName = intent.projectName {
            completion(INStringResolutionResult.success(with: projectName))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }

}
