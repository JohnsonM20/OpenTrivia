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
    let gameMode = (UIApplication.shared.delegate as! AppDelegate).data.gameMode
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if gameMode == GameTypes.freePlay{
            descriptionLabel.text = "You have as much time as you like to answer the amount of questions that you choose to answer. This is good practice for both timed modes and multiplayer modes!"
        } else if gameMode == GameTypes.timedMode{
            descriptionLabel.text = "You have one minute to answer as many questions correctly as you can. You gain 5 seconds for each correct answer, and lose 5 seconds for each wrong answer."
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
