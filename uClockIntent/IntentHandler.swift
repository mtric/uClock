//
//  IntentHandler.swift
//  uClockIntent
//
//  Created by Eric Walter on 05.01.21.
//

import Intents

/// Class to handle the intents
class IntentHandler: INExtension {
    
    /// Function handle the intents
    override func handler(for intent: INIntent) -> Any {
        
        switch intent {
        case is TrackTaskIntent:
            return StartTaskIntentHandler()
        case is StopTaskIntent:
            return StopTaskIntentHandler()
        default:
            // No intents should be unhandled so we’ll throw an error by default
            fatalError("No handler for this intent")
        }
    }
}
