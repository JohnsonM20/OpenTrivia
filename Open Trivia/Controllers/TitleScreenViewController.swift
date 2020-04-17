//
//  ViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 9/17/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit
import Network

class TitleScreenViewController: UIViewController {
    
    let monitor = NWPathMonitor()
    var settings = SettingsViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
                //TODO: Send an alert to inform of lost connection
            }
        }
        
        //Categories called ahead of time to prevent lag later
        settings.getTriviaCategoriesFromAPI()
    }
    
    @IBAction func FreePlay(_ sender: Any) {
        appDelegate.data.setGameMode(0)
    }
    
    @IBAction func Timed(_ sender: Any) {
        appDelegate.data.setGameMode(1)
    }
    
    
    @IBAction func Multiplayer(_ sender: Any) {
        appDelegate.data.setGameMode(2)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "play" {
            //create "destination view controller" and set properties on dvc
            if let nextViewController = segue.destination as? SettingsViewController {
                nextViewController.allTriviaCategories = settings.allTriviaCategories
                nextViewController.currentGameMode = appDelegate.data.getGameMode()
            }
        }
    }
}
