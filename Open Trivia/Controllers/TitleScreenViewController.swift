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
    let dataStore = (UIApplication.shared.delegate as! AppDelegate).data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0/255.0, green: 180/255.0, blue: 106/255.0, alpha: 1.0).cgColor, UIColor(red: 63/255.0, green: 161/255.0, blue: 200/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)

        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
                //TODO: Send an alert to inform of lost connection
            }
        }
    }
    
    @IBAction func FreePlay(_ sender: Any) {
        dataStore.currentGameMode = GameTypes.freePlay
    }
    
    @IBAction func Timed(_ sender: Any) {
        dataStore.currentGameMode = GameTypes.timedMode
    }
    
    @IBAction func Multiplayer(_ sender: Any) {
        dataStore.currentGameMode = GameTypes.startMultiplayer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "play" {
            //create "destination view controller" and set properties on dvc
            //if let nextViewController = segue.destination as? SettingsViewController {
                //nextViewController.allTriviaCategories = settings.allTriviaCategories
                //nextViewController.currentGameMode = appDelegate.data.getGameMode()
            //}
        }
    }
}
