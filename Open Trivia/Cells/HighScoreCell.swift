//
//  HighScoreCell.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 4/16/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit

class HighScoreCell: UITableViewCell {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var viewLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewLabel.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        viewLabel.layer.cornerRadius = 15
        viewLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
