//
//  GameDescription.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 4/16/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit

class GameDescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!
    let gameMode = (UIApplication.shared.delegate as! AppDelegate).data.currentGameMode
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundLabel.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        backgroundLabel.layer.cornerRadius = 15
        backgroundLabel.layer.masksToBounds = true
        
        if gameMode == GameTypes.freePlay{
            descriptionLabel.text = "You have as much time as you like to answer the set amount of questions. This is good practice for time trial!"
        } else if gameMode == GameTypes.timedMode{
            descriptionLabel.text = "You have one minute to answer as many questions correctly as you can. However, you lose 5 seconds for each wrong answer."
        } else if gameMode == GameTypes.startMultiplayer{
            descriptionLabel.text = "You are the game controller! Choose game options, wait for all players to join, then press start! Each player gains up to ten points for each correct answer. You may only answer once. You must answer within the alloted 10 seconds. There is a bonus for giving a correct answer quickly. Answers are revealed when all players answer."
        } else if gameMode == GameTypes.joinMultiplayer {
            descriptionLabel.text = "You have joined a game! Wait for the game controller to choose game options and for other players to join. Each player gains up to ten points for each correct answer. You may only answer once. You must answer within the alloted 10 seconds. There is a bonus for giving a correct answer quickly. Answers are revealed when all players answer."
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
