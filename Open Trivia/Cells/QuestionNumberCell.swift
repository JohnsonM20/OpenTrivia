//
//  QuestionNumberCell.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 4/15/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit

class QuestionNumberCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet var questionNumberAsked: UISegmentedControl!
    var dataStore = (UIApplication.shared.delegate as! AppDelegate).data

    override func awakeFromNib() {
        super.awakeFromNib()
        dataStore.totalAmountOfQuestions = 15
        questionNumberAsked.selectedSegmentIndex = 2
        //questionNumberAsked.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26)], for: .normal)
        
        questionNumberAsked.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        questionNumberAsked.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        borderView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        borderView.layer.cornerRadius = 15
        borderView.layer.masksToBounds = true
    }
    
    @IBAction func questionNumberChanged(_ sender: UISegmentedControl) {
        let questionAmount = Int(sender.titleForSegment(at: questionNumberAsked.selectedSegmentIndex)!) ?? 10
        dataStore.totalAmountOfQuestions = questionAmount
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
