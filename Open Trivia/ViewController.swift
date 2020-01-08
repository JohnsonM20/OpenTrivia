//
//  ViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 9/17/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        SettingsViewController.getTriviaCategoriesFromAPI()
        
    }
    
    @IBAction func FreePlay(_ sender: Any) {
        SettingsViewController.setCurrentGameMode(GameMode: 0)
    }
    
    @IBAction func Timed(_ sender: Any) {
        SettingsViewController.setCurrentGameMode(GameMode: 1)
    }
    
    
}

