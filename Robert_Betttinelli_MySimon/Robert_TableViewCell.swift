//
//  Robert_TableViewCell.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-03-28.
//

import UIKit

class Robert_TableViewCell: UITableViewCell {

    //MARK:- var
    var gameData : GameData?
    
    //MARK:- Outlets
    
    @IBOutlet weak var bestValue: UILabel!
    @IBOutlet weak var dateTimeValue: UILabel!
    @IBOutlet weak var userValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    
}
