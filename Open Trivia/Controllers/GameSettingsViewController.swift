//
//  GameSettingsViewController.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 12/21/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class GameSettingsViewController: UIViewController {

    @IBOutlet var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0/255.0, green: 180/255.0, blue: 106/255.0, alpha: 1.0).cgColor, UIColor(red: 63/255.0, green: 161/255.0, blue: 200/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: defaultsKeys.keyOne) {
            username.text = stringOne
        }
        /*
        if let stringTwo = defaults.string(forKey: defaultsKeys.keyTwo) {
            print(stringTwo) // Another String Value
        }
         */
    }
    

    @IBAction func changeUsername(_ sender: Any) {
        //print("Username: \(username.text)")
        let defaults = UserDefaults.standard
        defaults.set(username.text, forKey: defaultsKeys.keyOne)
        defaults.set("Another String Value", forKey: defaultsKeys.keyTwo)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct defaultsKeys {
    static let keyOne = "firstStringKey"
    static let keyTwo = "secondStringKey"
}
