//
//  RankingsView.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 2/4/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit

class RankingsViewController: UIViewController {
    
    var delegate: QuestionViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0/255.0, green: 180/255.0, blue: 106/255.0, alpha: 1.0).cgColor, UIColor(red: 63/255.0, green: 161/255.0, blue: 200/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func NextQuestion(_ sender: Any) {
        delegate.askNextQuestion()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //create "destination view controller"
        //set properties on dvc
        if let nextViewController = segue.destination as? QuestionViewController {
            nextViewController.askNextQuestion() //Or pass any values
        }
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
