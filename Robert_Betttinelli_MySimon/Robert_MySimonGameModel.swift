//
//  Robert_MySimonGameModel.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-03-28.
//

import Foundation
import UIKit

class Robert_MySimonGameModel{
    
    
    //MARK: Var
    var HttpModel = Robert_HTTP_PostModel()
    var simon_Seq : [Int] = []
    var user_Entry : Int = 0
    var isPastGame : Bool = false
    var turnCount : Int = 0
    var userTurnPointer : Int = 0
    
    //MARK: Functions
    func addTurn() {
        turnCount += 1
    }
    
    func setTurn(_ num : Int ) {
        turnCount = num
    }
    
    func getTurn() -> Int {
        return turnCount
    }
    
    func seqClearAll() {
        simon_Seq.removeAll()
        turnCount = 0
        userTurnPointer = 0
        user_Entry = 0
    }

    func simon_AddSeq(_ num : Int ) {
        simon_Seq.append(num)
    }

    
    func simon_AddSeqString(_ str: String) {
        let gamMoves = str.components(separatedBy: "|")
        let gameMovesInt = gamMoves.map { Int($0) }
        for move in 0..<gameMovesInt.count-1 {
            simon_AddSeq( gameMovesInt[move]!)
        }
        setTurn(simon_Seq.count)
    }
    
    func simon_getSeqString() -> String {
        var str : String = ""
        for seq in simon_Seq {
            str += String(seq) + "|"
        }
        return str
    }
    
    func seqAddRnd() {
        let rnd = Int.random(in: 1...4)
        simon_AddSeq(rnd)
        //simon_AddSeq(1)
    }
    
    //MARK: Check Button
    func compSeq(_ currUserSelect : Int) -> Bool {
        
        print ("-------------------CmpSeq")
        print ("Simon:\(simon_Seq)")
        print ("Current Select : \(currUserSelect)")
        print ("Compare: \(simon_Seq[userTurnPointer])")
        print ("Turn Pointer: \(userTurnPointer)")
        if currUserSelect == simon_Seq[userTurnPointer] {
            print(" Good.")
            print ("-------------------CmpSeq Done.")
            return true
        } else {
            print(" Bad.")
            print ("-------------------CmpSeq Done.")
            return false
        }   
    }
    
    //MARK: SAVE
    func saveGame() {
        if (isPastGame) {
            return
        }
        var username = NSUserName()
        if username.isEmpty  {
            username = "No Id"
        }
        let saveDate = Date()
        let numGamesPlayed = UserDefaults.standard.integer(forKey: Constants.NUM_GAMES)
        let gameNumber = numGamesPlayed + 1

        UserDefaults.standard.set(username, forKey: Constants.USER + String(gameNumber))
        UserDefaults.standard.set(turnCount, forKey: Constants.BEST + String(gameNumber))

        UserDefaults.standard.set(saveDate, forKey: Constants.DATE_TIME + String(gameNumber))
        UserDefaults.standard.set(simon_getSeqString() , forKey: Constants.ORDER_OF_MOVES + String(gameNumber))
        UserDefaults.standard.set(gameNumber, forKey: Constants.NUM_GAMES)
        print("Game Saved!")
        
        //MARK: HTTP Store
        //-------- HTTP POST FOR LADDER ON WEB (mysimon.io-serv.com)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dt = dateFormatter.string(from: saveDate)
        
        let url : String = "http://mysimon.io-serv.com/mywebservice.asmx/PostGame"
        let paramName : [String] = ["best","datetime","username"]
        let paramValue : [String] = [String(turnCount),dt,username]
        
        HttpModel.Post(url,paramName, paramValue)
    
    }

}

//MARK: Constants
struct Constants {
    static let NUM_GAMES = "numberOfGamesPlayed"
    static let USER = "user"
    static let BEST = "best"
    static let DATE_TIME = "datetime"
    static let ORDER_OF_MOVES = "orderOfMoves"
    static let SLIDER = "slider"
    static let AUDIOBOOL = "audioBool"
    static let AUDIOSET = "audioSet"
}
