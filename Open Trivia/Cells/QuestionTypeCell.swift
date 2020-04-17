//
//  QuestionTypeCell.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 4/16/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit

class QuestionTypeCell: UITableViewCell {
    
    @IBOutlet var questionTypeAsked: UIPickerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
