//
//  ViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 9/17/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //var numberOfQuestions = Int()
    
    override func viewDidLoad() {
        //print("hi")
        super.viewDidLoad()
        
        //let Settings = SettingsViewController(nibName: "Settings", bundle: nil)
        //let Settings = self.storyboard!.instantiateViewController(withIdentifier: "Settings")
        //let Settings = SettingsViewController(nibName: "Settings", bundle: nil)
        //let Settings = SettingsViewController()
        SettingsViewController.getCategories()
    }

}

