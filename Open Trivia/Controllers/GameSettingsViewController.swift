//
//  GameSettingsViewController.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 12/21/19.
//  Copyright © 2019 Matthew Johnson. All rights reserved.
//

import UIKit
import AVFoundation

class GameSettingsViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet weak var save: UIButton!
    
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var soundEffectSwitch: UISwitch!
    @IBOutlet weak var soundVisualSwitch: UISwitch!
    
    let dataStore = (UIApplication.shared.delegate as! AppDelegate).data
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        save.backgroundColor = UIColor(red: 129/255.0, green: 204/255.0, blue: 197/255.0, alpha: 1.0)
        save.layer.shadowColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0).cgColor
        save.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        save.layer.shadowOpacity = 1.0
        save.layer.cornerRadius = 20.0
        save.layer.shadowRadius = 0.0
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0/255.0, green: 180/255.0, blue: 106/255.0, alpha: 1.0).cgColor, UIColor(red: 63/255.0, green: 161/255.0, blue: 200/255.0, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        if defaults.bool(forKey: SoundTypes.isMusicPlaying) {
            musicSwitch.isOn = true
        } else {
            musicSwitch.isOn = false
        }
        
        if defaults.bool(forKey: SoundTypes.useSoundEffects) {
            soundEffectSwitch.isOn = true
        } else {
            soundEffectSwitch.isOn = false
        }
        
    }
    
    
    @IBAction func useMusicSwitchChanged(_ musicSwitch: UISwitch) {
        dataStore.playClickierSound()
        
        if musicSwitch.isOn {
            defaults.set(true, forKey: SoundTypes.isMusicPlaying)
            
        } else {
            defaults.set(false, forKey: SoundTypes.isMusicPlaying)
            
        }
    }
    
    @IBAction func useSoundEffectsChanged(_ soundEffectSwitch: UISwitch) {
        dataStore.playClickierSound()

        if soundEffectSwitch.isOn {
            defaults.set(true, forKey: SoundTypes.useSoundEffects)
            
        } else {
            defaults.set(false, forKey: SoundTypes.useSoundEffects)
        }
    }
    
    @IBAction func soundVisualChanged(_ visualSwitch: UISwitch) {
//        dataStore.playClickierSound()
//
//        if visualSwitch.isOn {
//            defaults.set(SoundTypes.yes, forKey: "\(SoundTypes.soundVisualOn)")
//        } else {
//            defaults.set(SoundTypes.no, forKey: "\(SoundTypes.soundVisualOn)")
//        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dataStore.playTinkSound()
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
