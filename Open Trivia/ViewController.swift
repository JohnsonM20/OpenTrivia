//
//  ViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 9/17/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    let monitor = NWPathMonitor()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
                //let alert = UIAlertController(title: "Oh-Oh!", message: "You are no longer connected to the internet.", preferredStyle: .alert)
                
                        // create the alert
                let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        SettingsViewController.getTriviaCategoriesFromAPI()
        
    }
    
    @IBAction func FreePlay(_ sender: Any) {
        SettingsViewController.setCurrentGameMode(GameMode: 0)
    }
    
    @IBAction func Timed(_ sender: Any) {
        SettingsViewController.setCurrentGameMode(GameMode: 1)
    }
    
    
    @IBAction func Multiplayer(_ sender: Any) {
        SettingsViewController.setCurrentGameMode(GameMode: 2)
    }
}

