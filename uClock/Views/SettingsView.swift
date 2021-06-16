//
//  SettingsView.swift
//  uClock
//
//  Created by Eric Walter on 05.12.20.
//

import SwiftUI

/// The settings view page with list of settings and credits
struct SettingsView: View {
    
    var body: some View {
        
        List {
            //MARK: - About
            Section(header: Text("Info")) {
                SettingsRowView(
                    destination: AnyView(AboutView()),
                    imageName: "info.circle",
                    text: "About"
                )
            }
            //MARK: - Credits
            Section {
                VStack {
                    Text("Created with ☕️ by Eric Walter")
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .font(.system(size: 14))
                    appVersionView
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                }
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Settings", displayMode: .inline)
        
    }
    
    /// Returns a text view with the app's version and build number
    private var appVersionView: some View {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            
            return Text("Version: \(version) (\(build))")
        } else {
            return Text("#chad")
        }
    }
}
