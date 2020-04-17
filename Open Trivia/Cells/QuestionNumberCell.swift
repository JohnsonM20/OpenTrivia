//
//  QuestionNumberCell.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 4/15/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit

class QuestionNumberCell: UITableViewCell {
    
    @IBOutlet var questionNumberAsked: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        questionNumberAsked.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        questionNumberAsked.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
    
    @IBAction func questionNumberChanged(_ sender: UISegmentedControl) {
        if #available(iOS 13.0, *) {
            //sender.selectedSegmentTintColor = .black
            //sender.
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
