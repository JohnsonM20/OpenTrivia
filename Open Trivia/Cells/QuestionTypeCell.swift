//
//  QuestionTypeCell.swift
//  Open Trivia
//
//  Created by Matthew Johnson on 4/16/20.
//  Copyright © 2020 Matthew Johnson. All rights reserved.
//

import UIKit

class QuestionTypeCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var questionTypeAsked: UIPickerView!
    
    var dataStore = (UIApplication.shared.delegate as! AppDelegate).data
    var currentRowSelectedInPicker = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        dataStore.currentTriviaCategoryID = 0
        
        borderView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        borderView.layer.cornerRadius = 15
        borderView.layer.masksToBounds = true

        questionTypeAsked.dataSource = self
        questionTypeAsked.delegate = self
        questionTypeAsked.selectRow(currentRowSelectedInPicker, inComponent: 0, animated: true)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        currentRowSelectedInPicker = row
        
        if row == 0{
            dataStore.currentTriviaCategoryID = 0
        } else {
            dataStore.currentTriviaCategoryID = dataStore.allTriviaCategories[row-1].id
        }
        
        if dataStore.currentGameMode == GameTypes.joinMultiplayer || dataStore.currentGameMode == GameTypes.startMultiplayer{
            //multiService.send(ObjectAndChangedTo: "\(send.pickerQuestionType)\(questionTypePicker.selectedRow(inComponent: 0))")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataStore.allTriviaCategories.count+1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        for category in dataStore.allTriviaCategories {
            category.name = category.name.replacingOccurrences(of: "Entertainment: ", with: "").replacingOccurrences(of: "Science: ", with: "")
        }
        dataStore.allTriviaCategories = dataStore.allTriviaCategories.sorted()
        
        if row == 0{
            return NSAttributedString(string: "All Questions", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        } else {
            return NSAttributedString(string: dataStore.allTriviaCategories[row-1].name, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
}
