//
//  AddNewTimerView.swift
//  uClock
//
//  Created by Eric Walter on 09.12.20.
//

import SwiftUI

/// Modal sheet view to add a new timer
struct AddNewTimerView: View {
    
    /// Use SceneStorage to save text input when app goes to background
    @SceneStorage("clientName") private var clientName: String = ""
    @SceneStorage("projectName") private var projectName: String = ""
    @SceneStorage("taskName") private var taskName: String = ""
    
    @State var myTimerData: MyTimerData = MyTimerData()
    @Binding var showModalSheet: Bool
    @State var statusColor: Color = .black
    @State var buttonColor: UIColor = .systemBlue
    @State var status: String = "Enter a project and task name"
    
    var body: some View {
        
        VStack {
            Form {
                TextField("Client (optional)", text: $clientName)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Project", text: $projectName)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Task", text: $taskName)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    Spacer()
                    Text(status)
                        .font(.footnote)
                        .foregroundColor(statusColor)
                    Spacer()
                }
                VStack{
                    HStack {
                        ColoredButtonTile(
                            buttonColor: $buttonColor,
                            tileColor: .systemBlue)
                            .padding()
                        ColoredButtonTile(
                            buttonColor: $buttonColor,
                            tileColor: .systemYellow)
                            .padding()
                        ColoredButtonTile(
                            buttonColor: $buttonColor,
                            tileColor: .systemPink)
                            .padding()
                    }
                    HStack {
                        ColoredButtonTile(
                            buttonColor: $buttonColor,
                            tileColor: .systemOrange)
                            .padding()
                        ColoredButtonTile(
                            buttonColor: $buttonColor,
                            tileColor: .systemGreen)
                            .padding()
                        ColoredButtonTile(
                            buttonColor: $buttonColor,
                            tileColor: .systemPurple)
                            .padding()
                    }
                }
            }
        }
        .navigationBarItems(
            leading: Button(
                action: {
                    showModalSheet = false
                    clientName = ""
                    projectName = ""
                    taskName = ""
                    statusColor = .black
                },
                label: { Text("Cancel") }
            ),
            trailing: Button(
                action: { addTimer() },
                label: { Text("Add").bold() }
            )
        )
        .navigationBarTitle(Text("Add Timer"), displayMode: .inline)
    }
    
    /// Save new timer to myTimerData, which gets displayed in the list
    private func addTimer() {
        
        if (projectName == "" || taskName == "") {
            statusColor = .red
            status = "Please enter a project and task name"
        } else {
            if myTimerData.saveMyTimer(projectName: projectName, clientName: clientName, taskName: taskName, storedElapsed: 0, startTimeStamp: Date(), stopTimeStamp: Date(), isRunning: false, timerColor: buttonColor) {
                status = "Timer added"
                clientName = ""
                projectName = ""
                taskName = ""
                statusColor = .black
                
                // close model view
                showModalSheet = false
            }
        }
    }
}

/// A single colored button tile, which displays a checkmark when clicked
struct ColoredButtonTile: View {
    
    @Binding var buttonColor: UIColor
    var tileColor: UIColor
    
    var body: some View {
        Button(
            action: { buttonColor = tileColor },
            label: {
                ZStack{
                    RoundedRectangle(
                        cornerRadius: 12.0,
                        style: .continuous
                    )
                    .frame(
                        width: 60,
                        height: 60,
                        alignment: .center)
                    .foregroundColor(Color(tileColor))
                    
                    if tileColor == buttonColor {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                            .foregroundColor(.white)
                    }
                }
            }
        )
        .buttonStyle(PlainButtonStyle())
    }
}
