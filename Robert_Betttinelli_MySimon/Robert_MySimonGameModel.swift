//
//  Robert_MySimonGameModel.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-03-28.
//

import Foundation

class Robert_MySimonGameModel{
    
    var simon_Seq : [Int] = []
    var user_Seq : [Int] = []
    
    func seqClearAll() {
        simon_Seq.removeAll()
        user_Seq.removeAll()
    }
    
    func seqClearUser() {
        user_Seq.removeAll()
    }
    
    func simon_AddSeq(_ num : Int ) {
        simon_Seq.append(num)
    }
    
    func user_AddSeq(_ num : Int ) {
        user_Seq.append(num)
    }
    
    func seqAddRnd() {
        let rnd = Int.random(in: 1...4)
        simon_AddSeq(rnd)
    }
    
    func compSequece() -> Bool {
        
        var seqToCheck : [Int] = []
        for x in Range(0...user_Seq.count-1) {
            seqToCheck.append(simon_Seq[x])
        }
        print( "User \(user_Seq) to \(seqToCheck)")
        return user_Seq.elementsEqual(seqToCheck)
        
    }

}

struct Constants {
    static let NUM_GAMES = "numberOfGamesPlayed"
    static let USER = "user"
    static let BEST = "best"
    static let DATE_TIME = "datetime"
    static let ORDER_OF_MOVES = "orderOfMoves"
}
