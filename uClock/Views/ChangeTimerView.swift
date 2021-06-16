//
//  ChangeTimerView.swift
//  uClock
//
//  Created by Eric Walter on 08.02.21.
//

import SwiftUI

/// Modal sheet view to change the timer data
struct ChangeTimerView: View {
    
    @State var myTimer: MyTimer
    @State var myTimerData: MyTimerData
    @Binding var showModalSheet: Bool
    @State private var clientName: String = ""
    @State private var projectName: String = ""
    @State private var taskName: String = ""
    @State var status: String = "Enter a project and task name"
    @State var statusColor: Color = .black
    @State var buttonColor: UIColor = .systemBlue
    
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
                VStack {
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
                /// List with "Add to Siri" buttons
                List {
                    VStack {
                        Text("Start this timer with voice")
                        IntentIntegratetController(projectName: $projectName, taskName: $taskName, isStartFunction: true)
                            .frame(height: 50)
                            .padding(.bottom, 5)

                    }
                    VStack {
                        Text("Stop this timer with voice")
                        IntentIntegratetController(projectName: $projectName, taskName: $taskName, isStartFunction: false)
                            .frame(height: 50)
                            .padding(.bottom, 5)
                    }
                }
            }
        }
        /// Load timer data when view is about to appear
        .onAppear() {
            print("ChangeTimerView onAppear()")
            clientName = myTimer.clientName ?? ""
            projectName = myTimer.projectName
            taskName = myTimer.taskName
            buttonColor = myTimer.timerColor
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
                action: { changeTimer() },
                label: { Text("Change").bold() }
            )
        )
        .navigationBarTitle(Text("Change Timer"),
                            displayMode: .inline)
    }
    
    /// Function to update the timer data in myTimerData object
    private func changeTimer() {
        
        if (projectName == "" || taskName == "") {
            statusColor = .red
            status = "Please enter a project and task name"
        } else {
            if myTimerData.changeMyTimer(myTimer: myTimer, projectName: projectName, clientName: clientName, taskName: taskName, timerColor: buttonColor) {
                status = "Timer added"
                clientName = ""
                projectName = ""
                taskName = ""
                statusColor = .black
                
                /// Close modal sheet view
                showModalSheet = false
            }
        }
    }
}
