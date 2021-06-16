//
//  SettingsRowView.swift
//  uClock
//
//  Created by Eric Walter on 05.12.20.
//

import SwiftUI

/// Single row item in the list of settings
struct SettingsRowView: View {
    
    let destination: AnyView
    var imageName: String
    var text: String
    
    var body: some View {
        
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: imageName)
                Text(text)
            }
        }
    }
}
