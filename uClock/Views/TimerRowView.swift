//
//  TaskRowView.swift
//  uClock
//
//  Created by Eric Walter on 05.12.20.
//

import SwiftUI
import Intents

/// Row item of a list timers
struct TimerRowView: View {
    
    var myTimer: MyTimer
    @State var myTimerData: MyTimerData
    @State var currentDate = Date()
    @State var displayTime: String = ""
    @State var isRunning = false
    @State var showingChangeTimer: Bool = false
    
    /// trigger a system timer every 100 milliseconds
    let timer = Timer.publish(every: 0.1, tolerance: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        HStack {
            /// Group the elements on the left together
            Group {
                HStack {
                    ZStack {
                        RoundedRectangle(
                            cornerRadius: 25.0,
                            style: .continuous)
                            .foregroundColor(Color(myTimer.timerColor))
                            .frame(width: 80, height: 50, alignment: .center)
                        Text("\(displayTime)")
                            .foregroundColor(.white)
                            /// refresh displayed time and timer status on triggered system timer
                            .onReceive(timer) { _ in
                                displayTime = showDisplayTime()
                                isRunning = myTimer.isRunning
                            }
                    }
                    Text(myTimer.projectName)
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 5, height: 5)
                        .foregroundColor(.black)
                    Text("\(myTimer.taskName)")
                }
            }
            .onTapGesture {
                showingChangeTimer.toggle()
            }
            .sheet(
                isPresented: $showingChangeTimer,
                onDismiss: {
                    showingChangeTimer = false
                    myTimerData.refresh()
                },
                content: {
                    NavigationView{
                        ChangeTimerView(myTimer: myTimer, myTimerData: myTimerData, showModalSheet: $showingChangeTimer)
                    }
                }
            )
            Spacer()
            Button(
                action: {
                    if isRunning {
                        withAnimation {
                            if myTimerData.pauseMyTimer(myTimer: myTimer){
                                print("Timer paused!")
                            }
                        }
                    } else {
                        withAnimation {
                            if myTimerData.startMyTimer(myTimer: myTimer) {
                                print("Timer started!")
                            }
                        }
                    }
                },
                label: {
                    if isRunning {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                }
            )
            .buttonStyle(PlainButtonStyle())
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
        }
    }
    
    /// Function to calculate and return the elapsed time of a timer as a string
    func showDisplayTime() -> String {
        
        var displayTime: Int = 0
        if myTimer.startTimeStamp > myTimer.stopTimeStamp {
            let currentTimeStamp = Date()
            let elapsed = currentTimeStamp.timeIntervalSince(myTimer.startTimeStamp)
            displayTime = myTimer.storedElapsed + Int(floor(elapsed))
        } else {
            displayTime = myTimer.storedElapsed
        }
        
        return convertCountToTimeString(counter: displayTime)
    }
    
    /// Function to return a formatted time string (00:00:00) from counted seconds
    func convertCountToTimeString(counter: Int) -> String {
        
        let hours: Int = abs(counter / 3600)
        let minutes: Int = abs((counter - (hours * 3600)) / 60)
        let seconds: Int = abs(counter - (hours * 3600) - (minutes * 60))
        
        var secondsString = "\(seconds)"
        var minutesString = "\(minutes)"
        var hoursString = "\(hours)"
        
        if seconds < 10 {
            secondsString = "0" + secondsString
        }
        
        if minutes < 10 {
            minutesString = "0" + minutesString
        }
        
        if hours < 10 {
            hoursString = "0" + hoursString
        }
        
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
}
