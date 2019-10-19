//
//  EndgameViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 10/3/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit

class EndgameViewController: UIViewController {
    var rightAnswers = Int(1)
    var totalClicks = Int(1)
    @IBOutlet var GuessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var file = "rightAnswers.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                let userData = try String(contentsOf: fileURL, encoding: .utf8)
                rightAnswers = Int(userData) ?? 0
            }
            catch {}
        }
        
        file = "totalClicks.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                let userData = try String(contentsOf: fileURL, encoding: .utf8)
                totalClicks = Int(userData) ?? 0
            }
            catch {}
        }
        print(rightAnswers)
        print(totalClicks)
        //Float(round(1000*x)/1000)
        GuessLabel.text = ("You guessed with a \(round(Float(rightAnswers)*100.0/Float(totalClicks))*1000/1000) % accuracy.")
        
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
