//
//  AddTaskRowView.swift
//  uClock
//
//  Created by Eric Walter on 07.12.20.
//

import SwiftUI

/// A single row item in a list to act as button to add a timer
struct AddTaskRowView: View {
    
    var body: some View {
        
        HStack {
            Text("Add timer")
                .padding(.all)
            Spacer()
            Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
        }
    }
}
