//
//  WelcomeView.swift
//  uClock
//
//  Created by Eric Walter on 05.12.20.
//

import SwiftUI

/// Main app window
struct WelcomeView: View {
    
    @Environment(\.presentationMode) private var presentation
    
    /// Use AppGroups with UserDefaults to store data
    @AppStorage("timerstorage", store: UserDefaults(suiteName: "group.dev.ericwalter")) var store: Data = Data()
    
    @State var myTimerData: MyTimerData = MyTimerData()
    
    @State var showingAddNewTimer: Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .center, spacing: 30){
                List {
                    /// Add timers from myTimerData to List
                    ForEach(myTimerData.myTimers) { item in
                        TimerRowView(myTimer: item, myTimerData: myTimerData)
                    }
                    /// Left swipe of List item triggers delete function
                    .onDelete { indexSet in
                        for index in indexSet {
                            if myTimerData.deleteMyTimer(index: index){
                                print("Timer deleted")
                            }
                        }
                    }
                    AddTaskRowView()
                        .onTapGesture {
                            showingAddNewTimer.toggle()
                        }
                        .sheet(
                            isPresented: $showingAddNewTimer,
                            onDismiss: {
                                showingAddNewTimer = false
                                myTimerData.refresh()
                            },
                            content: {
                                NavigationView{
                                    AddNewTimerView(showModalSheet: $showingAddNewTimer)
                                }
                            }
                        )
                }
            }
            .onAppear() {
                print("WelcomeView: onAppear")
                myTimerData.refresh()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                myTimerData.refresh()
                print("Moving back to the foreground!")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                myTimerData.refresh()
                print("Did become active!")
            }
            .navigationBarTitle(
                displayCurrentDate(),
                displayMode: .inline)
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: SettingsView()
                ) { Image(systemName: "gearshape") }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// Function returning the current Date as a String
    func displayCurrentDate() -> String {
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        let date = formatter.string(from: currentDate)
        
        return date
    }
}
