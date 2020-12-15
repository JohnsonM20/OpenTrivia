//
//  ViewController.swift
//  FirstQuizGame
//
//  Created by Matthew Johnson on 9/17/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit
import Network
import AVFoundation

class TitleScreenViewController: UIViewController {
    
    @IBOutlet weak var freePlay: UIButton!
    @IBOutlet weak var timeTrial: UIButton!
    @IBOutlet weak var settings: UIButton!
    
    let monitor = NWPathMonitor()
    let dataStore = (UIApplication.shared.delegate as! AppDelegate).data
    var audioPlayer = AVAudioPlayer()
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: SoundTypes.isMusicPlaying) {
            let randomSong = SoundTypes.allLightMusic.randomElement()!
            print(randomSong)
            let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "\(randomSong)", ofType: "mp3")!)
            audioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        freePlay.backgroundColor = UIColor(red: 129/255.0, green: 204/255.0, blue: 197/255.0, alpha: 1.0)
        freePlay.layer.shadowColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0).cgColor
        freePlay.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        freePlay.layer.shadowOpacity = 1.0
        freePlay.layer.cornerRadius = 20.0
        freePlay.layer.shadowRadius = 0.0
        
        timeTrial.backgroundColor = UIColor(red: 129/255.0, green: 204/255.0, blue: 197/255.0, alpha: 1.0)
        timeTrial.layer.shadowColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0).cgColor
        timeTrial.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        timeTrial.layer.shadowOpacity = 1.0
        timeTrial.layer.cornerRadius = 20.0
        timeTrial.layer.shadowRadius = 0.0
        
        settings.backgroundColor = UIColor(red: 129/255.0, green: 204/255.0, blue: 197/255.0, alpha: 1.0)
        settings.layer.shadowColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0).cgColor
        settings.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        settings.layer.shadowOpacity = 1.0
        settings.layer.cornerRadius = 20.0
        settings.layer.shadowRadius = 0.0
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0/255.0, green: 180/255.0, blue: 106/255.0, alpha: 1.0).cgColor, UIColor(red: 63/255.0, green: 161/255.0, blue: 200/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
                //TODO: Send an alert to inform of lost connection
            }
        }
    }
    
    @IBAction func FreePlay(_ sender: Any) {
        dataStore.currentGameMode = GameTypes.freePlay
    }
    
    @IBAction func Timed(_ sender: Any) {
        dataStore.currentGameMode = GameTypes.timedMode
    }
    
    @IBAction func Multiplayer(_ sender: Any) {
        dataStore.currentGameMode = GameTypes.startMultiplayer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        audioPlayer.stop()
        dataStore.playTinkSound()
        
        if segue.identifier == "play" {
            //create "destination view controller" and set properties on dvc
            //if let nextViewController = segue.destination as? SettingsViewController {
                //nextViewController.allTriviaCategories = settings.allTriviaCategories
                //nextViewController.currentGameMode = appDelegate.data.getGameMode()
            //}
        }
    }
}
