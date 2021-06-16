//
//  SiriButtonIntentController.swift
//  uClock
//
//  Created by Julian Beck https://blog.julianbeck.com/swiftui/add-to-siri-in-swiftui/ (accessed 09.02.21.)
//
//  Modified by Eric Walter on 09.02.21.
//

import SwiftUI
import UIKit
import IntentsUI

/// Class to create an "Add to Siri" Button and handle the intents
class SiriButtonIntentController: UIViewController, INUIAddVoiceShortcutViewControllerDelegate{
    
    @State private var projectName: String
    @State private var taskName: String
    private var isStartFunction: Bool
    
    init(projectName: String, taskName: String, isStartFunction: Bool) {
        
        self.projectName = projectName
        self.taskName = taskName
        self.isStartFunction = isStartFunction
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    //Add to Siri Button
        let button = INUIAddVoiceShortcutButton(style: .whiteOutline)
        
        self.view.addSubview(button)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        if isStartFunction {
            button.addTarget(self,action: #selector(startTimeTrackingIntent),for: .touchUpInside)
        } else {
            button.addTarget(self,action: #selector(stopTimeTrackingIntent),for: .touchUpInside)
        }
    }
    
    
    @objc func startTimeTrackingIntent() {
        
        //add Intent
        let suggentedPhrase = "Start tracking for \(projectName) \(taskName)"
        let intent = TrackTaskIntent()
        
        intent.suggestedInvocationPhrase = suggentedPhrase
        intent.projectName = projectName
        intent.taskName = taskName
        if let shortcut = INShortcut(intent: intent) {
            
            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            
            viewController.modalPresentationStyle = .formSheet
            viewController.delegate = self // Object conforming to `INUIAddVoiceShortcutViewControllerDelegate`.
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func stopTimeTrackingIntent() {
        
        //add Intent
        let suggentedPhrase = "Stop tracking for \(projectName) \(taskName)"
        let intent = StopTaskIntent()
        
        intent.suggestedInvocationPhrase = suggentedPhrase
        intent.projectName = projectName
        intent.taskName = taskName
        if let shortcut = INShortcut(intent: intent) {
            
            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            
            viewController.modalPresentationStyle = .formSheet
            viewController.delegate = self // Object conforming to `INUIAddVoiceShortcutViewControllerDelegate`.
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        
        controller.dismiss(animated: true) {
            
        }
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }

}

extension SiriButtonIntentController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        
        addVoiceShortcutViewController.delegate = self
        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        
        editVoiceShortcutViewController.delegate = self
        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
    
}

/// Use UIViewControllerRepresentable to create "Add to Siri" Button in SwiftUI
struct IntentIntegratetController: UIViewControllerRepresentable {
    
    @Binding var projectName: String
    @Binding var taskName: String
    var isStartFunction: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<IntentIntegratetController>) -> SiriButtonIntentController {
        
        return SiriButtonIntentController(projectName: projectName, taskName: taskName, isStartFunction: isStartFunction)
    }
    
    func updateUIViewController(_ uiViewController: SiriButtonIntentController, context: UIViewControllerRepresentableContext<IntentIntegratetController>) {
        
    }
    
    typealias UIViewControllerType = SiriButtonIntentController

}
