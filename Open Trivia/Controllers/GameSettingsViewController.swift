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
    
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var buttonSwitch: UISwitch!
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
        
        if defaults.integer(forKey: "\(SoundTypes.soundOn)") == SoundTypes.yes{
            soundSwitch.isOn = true
        } else {
            soundSwitch.isOn = false
        }
        
        if defaults.integer(forKey: "\(SoundTypes.buttonOn)") == SoundTypes.yes{
            buttonSwitch.isOn = true
        } else {
            buttonSwitch.isOn = false
        }
        
        if defaults.integer(forKey: "\(SoundTypes.soundVisualOn)") == SoundTypes.yes{
            soundVisualSwitch.isOn = true
        } else {
            soundVisualSwitch.isOn = false
        }
        
    }
    
    
    @IBAction func soundSwitchChanged(_ soundSwitch: UISwitch) {
        dataStore.playClickierSound()
        
        if soundSwitch.isOn{
            defaults.set(SoundTypes.yes, forKey: "\(SoundTypes.soundOn)")
            soundVisualSwitch.isEnabled = true
        } else {
            defaults.set(SoundTypes.no, forKey: "\(SoundTypes.soundOn)")
            defaults.set(SoundTypes.no, forKey: "\(SoundTypes.soundVisualOn)")
            soundVisualSwitch.isOn = false
            soundVisualSwitch.isEnabled = false
        }
    }
    
    @IBAction func buttonSoundChanged(_ visualSwitch: UISwitch) {
        dataStore.playClickierSound()

        if buttonSwitch.isOn{
            defaults.set(SoundTypes.yes, forKey: "\(SoundTypes.buttonOn)")
        } else {
            defaults.set(SoundTypes.no, forKey: "\(SoundTypes.buttonOn)")
        }
    }
    
    @IBAction func soundVisualChanged(_ visualSwitch: UISwitch) {
        dataStore.playClickierSound()
        
        if visualSwitch.isOn{
            defaults.set(SoundTypes.yes, forKey: "\(SoundTypes.soundVisualOn)")
        } else {
            defaults.set(SoundTypes.no, forKey: "\(SoundTypes.soundVisualOn)")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dataStore.playTinkSound()
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
