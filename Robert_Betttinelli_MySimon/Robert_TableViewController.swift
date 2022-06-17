//
//  Robert_TableViewController.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-03-28.
//

import UIKit

class Robert_TableViewController: UITableViewController {

    var gameDataArray = [GameData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func loadData() {
        let numberOfGamesPlayed = UserDefaults.standard.integer(forKey: Constants.NUM_GAMES)
        gameDataArray = [GameData]()
        
        //best, user, datetime, Order
        for i in (0..<numberOfGamesPlayed).reversed() {
            let gameNumber = i + 1
            
            let bestThisGame = UserDefaults.standard.string(forKey: Constants.BEST+String(gameNumber))
            
            let userThisGame = UserDefaults.standard.string(forKey: Constants.USER+String(gameNumber))
            
            let dateTimeThisGame = UserDefaults.standard.object(forKey: Constants.DATE_TIME+String(gameNumber)) as! Date
            
            let orderOfMovesThisGame = UserDefaults.standard.string(forKey: Constants.ORDER_OF_MOVES+String(gameNumber))
            
            let thisGameData = GameData(best: bestThisGame!, user: userThisGame!,dateTime: dateTimeThisGame, orderOfMoves: orderOfMovesThisGame!)
            
            gameDataArray.append(thisGameData)

        }
        gameDataArray = gameDataArray.sorted(by: { $0.best > $1.best })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserDefaults.standard.integer(forKey: Constants.NUM_GAMES)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "robert_tableCell", for: indexPath) as! Robert_TableViewCell

        // Configure the cell...
        let rowNumber = indexPath.row
        
        //best, user, datetime, Order
        let thisRowData = gameDataArray[rowNumber]

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        dateFormatter.locale = Locale(identifier: "en_US")
        
        cell.bestValue.text = thisRowData.best
        cell.userValue.text = thisRowData.user
        cell.dateTimeValue.text = dateFormatter.string(from: thisRowData.dateTime)
        cell.gameData = thisRowData
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         //let identifier = segue.identifier
         
         let whichCell =  sender as! Robert_TableViewCell
         let destinationView = segue.destination as! Robert_GameViewController
         destinationView.replayingPastGame = true
         destinationView.pastGameData = whichCell.gameData
         
     }
    
    

}

struct GameData {
    var best : String
    var user : String
    var dateTime : Date
    var orderOfMoves : String
}
