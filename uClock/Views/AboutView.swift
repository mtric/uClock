//
//  AboutView.swift
//  uClock
//
//  Created by Eric Walter on 09.02.21.
//

import SwiftUI

/// View to display the about me information in the settings
struct AboutView: View {
    
    var body: some View {
        
        List {
            Section() {
                Text("uClock Time Tracker")
                    .font(.system(size: 28))
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
            
            Section() {
                VStack(alignment: .leading, spacing: 16) {
                    Text("👋 Hey, I'm Eric Walter,")
                    Text("I'm a business computer science student at the Berlin School of Economics and Law. Currently, I have a huge interest in learning Web techniques and Full Stack development as well as native App development. Besides that I love drinking coffee and seeing the world!")
                    Text("The uClock App is a free App to track your freelance worktime fast and with your voice.")
                    Text("Thanks for downloading my App, I hope you enjoy it!")
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("About", displayMode: .inline)
    }
}
