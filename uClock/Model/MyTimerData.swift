//
//  MyTimerData.swift
//  uClock
//
//  Created by Eric Walter on 03.02.21.
//

import SwiftUI
import Intents

/// Structure of codable timer data to control the timers in the timer store
struct MyTimerData: Codable {
    
    /// Array of timers
    var myTimers: [MyTimer]
    
    /// Create empty timer array and fill it with timers from timer store on initialization
    init() {
        
        myTimers = []
        refresh()
    }
    
    /// Function to receive timer array from timer store
    mutating func refresh() {
        
        myTimers = MyTimerStore().getMyTimers()
    }
    
    /// Function to save a new timer to timer store
    mutating func saveMyTimer(projectName: String, clientName: String?, taskName: String, storedElapsed: Int, startTimeStamp: Date, stopTimeStamp: Date, isRunning: Bool, timerColor: UIColor) -> Bool {
        
        myTimers.append(MyTimer(projectName: projectName, clientName: clientName, taskName: taskName, storedElapsed: storedElapsed, startTimeStamp: startTimeStamp, stopTimeStamp: stopTimeStamp, isRunning: isRunning, timerColor: timerColor))

        donateTrackTaskIntent(projectName: projectName, taskName: taskName)
        
        return MyTimerStore().update(myTimerData: self)
    }
    
    /// Function to change the timer data in timer store
    mutating func changeMyTimer(myTimer: MyTimer, projectName: String, clientName: String?, taskName: String, timerColor: UIColor) -> Bool {
        
        myTimer.projectName = projectName
        myTimer.clientName = clientName
        myTimer.taskName = taskName
        myTimer.timerColor = timerColor
        
        return MyTimerStore().update(myTimerData: self)
    }
    
    /// Function to delete timer in timer store
    mutating func deleteMyTimer(index: Int) -> Bool {
        
        myTimers.remove(at: index)
        
        return MyTimerStore().update(myTimerData: self)
    }
    
    /// Function to start a timer
    func startMyTimer(myTimer: MyTimer) -> Bool {
        
        /// Set starting timestamp to now
        myTimer.startTimeStamp = Date()
        myTimer.isRunning = true
        
        /// Donate this action to Siri shortcuts
        donateTrackTaskIntent(projectName: myTimer.projectName, taskName: myTimer.taskName)
        
        return MyTimerStore().update(myTimerData: self)
    }
    
    /// Function to pause a timer
    func pauseMyTimer(myTimer: MyTimer) -> Bool {
        
        let currentTimeStamp = Date()
        
        /// Set stop timestamp to now
        myTimer.stopTimeStamp = currentTimeStamp
        
        /// The new stored elapsed time equals the previously stored time plus the time between the last start timestamp and now
        myTimer.storedElapsed = myTimer.storedElapsed + Int(currentTimeStamp.timeIntervalSince(myTimer.startTimeStamp))
        myTimer.isRunning = false
        
        /// Donate this action to Siri shortcuts
        donateStopTaskIntent(projectName: myTimer.projectName, taskName: myTimer.taskName)
        
        return MyTimerStore().update(myTimerData: self)
    }
    
    /// Function to donate start intent to Siri shortcuts
    func donateTrackTaskIntent(projectName: String, taskName: String) {
        
        let intent = TrackTaskIntent()
        intent.projectName = projectName
        intent.taskName = taskName
        intent.suggestedInvocationPhrase = "Track my time for \(projectName) \(taskName)"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Donation failed: %@" + error.localizedDescription)
                }
            } else {
                print("Successfully donated interaction")
            }
        }
    }
    
    /// Function to donate stop intent to Siri shortcuts
    func donateStopTaskIntent(projectName: String, taskName: String) {
        
        let intent = StopTaskIntent()
        intent.projectName = projectName
        intent.taskName = taskName
        intent.suggestedInvocationPhrase = "Stop tracking for \(projectName) \(taskName)"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Donation failed: %@" + error.localizedDescription)
                }
            } else {
                print("Successfully donated interaction")
            }
        }
    }
}
