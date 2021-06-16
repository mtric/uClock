//
//  IntentViewController.swift
//  uClockIntentUI
//
//  Created by Eric Walter on 05.01.21.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
//    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
//        
//        guard let intent = interaction.intent as? TrackTaskIntent else {
//            completion(false, Set(), .zero)
//            return
//        }
//        
//        if let projectName = intent.projectName, let taskName = intent.taskName {
//            self.contentLabel.text = "Track time for \(projectName) \(taskName)?"
//        }
//        
//        completion(true, parameters, self.desiredSize)
//    }
    
    var desiredSize: CGSize {
//        return self.extensionContext!.hostedViewMaximumAllowedSize
        return CGSize.init(width: 10, height: 100)
    }
    
}
