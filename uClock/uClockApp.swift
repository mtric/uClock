//
//  uClockApp.swift
//  uClock
//
//  Created by Eric Walter on 05.12.20.
//

import SwiftUI
import Intents

@main
struct MyHoursApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
        .onChange(of: scenePhase) { phase in
            /// Ask user to authorize Siri usage on first start
            INPreferences.requestSiriAuthorization({ status in
                switch (status) {
                case .authorized:
                    print("Siri usage got authorized.")
                case .denied, .notDetermined, .restricted:
                    print("Siri usage NOT authorized.")
                @unknown default:
                    print("Unknown error with Siri usage.")
                }
            })
        }
    }
}
