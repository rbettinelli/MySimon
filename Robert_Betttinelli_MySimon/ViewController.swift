//
//  ViewController.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-03-20.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var BtnPlay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // UserDefaults.resetDefaults()
    }
    
}

// Global Setting of Sound Sets. - More can be added.
// Assets must follow nameX - where X is the button and
// nameE where it plays the end of game sound.
struct SoundValues {
     static var listOfSounds = ["default","nintendo"]
}

// This allows for Removal of all the UserDefaults
extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
