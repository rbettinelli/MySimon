//
//  Robert_GameSettingsViewController.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-04-07.
//

import UIKit

class Robert_GameSettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var myRow : Int = 0
    var mySpeed : Int = 0
    
    @IBOutlet weak var sliderSelect: UISlider!
    
    @IBAction func speedSlider(_ sender: UISlider) {
        // Store Value
        let currentValue = Int(sender.value)
        speedDisplay.text = String(currentValue)
    }
    
    @IBOutlet weak var speedDisplay: UILabel!
    @IBOutlet weak var audioSwitch: UISwitch!
    @IBOutlet weak var soundPicker: UIPickerView!
    
    @IBAction func buttonSave(_ sender: UIButton) {
        saveButtonValues()
    }
    
    //MARK: UIPicker Stubs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SoundValues.listOfSounds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SoundValues.listOfSounds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Row Selected
        print("Selected \(row) in \(component)")
        myRow = row
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPicker.dataSource = self
        soundPicker.delegate = self
        pickerView(soundPicker, didSelectRow: 0, inComponent: 0)
        
        let row: Int = UserDefaults.standard.integer(forKey: Constants.AUDIOSET)
        self.soundPicker.selectRow(row, inComponent: 0, animated: false)
        
        let switchValue = UserDefaults.standard.bool(forKey: Constants.AUDIOBOOL)
        audioSwitch.setOn(switchValue, animated: true)
        
        let slider = UserDefaults.standard.float(forKey: Constants.SLIDER)
        sliderSelect.value = slider
        speedDisplay.text = String(slider)
        
    }
    
    func saveButtonValues() {
        
        mySpeed = Int(speedDisplay.text!) ?? 2
        UserDefaults.standard.set(mySpeed, forKey: Constants.SLIDER)
        
        var mySwitch : Bool = false
        if audioSwitch.isOn {
            mySwitch = true
        }
        UserDefaults.standard.set(mySwitch, forKey: Constants.AUDIOBOOL)
        
        UserDefaults.standard.set(myRow, forKey: Constants.AUDIOSET)
        
    }
    
    
}
