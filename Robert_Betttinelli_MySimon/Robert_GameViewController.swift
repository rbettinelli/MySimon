//
//  Robert_GameViewController.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-03-28.
//

import UIKit
import AVFoundation

class Robert_GameViewController: UIViewController {

    //MARK:- Enumerations
    enum GameUser {
        case CPU, USER ,UNKNOWN
    }
    
    //MARK:- Class var.
    var theGameModel = Robert_MySimonGameModel()
    var audioPlayer = Robert_Audio()
    var gameFinished = false
    var pastGameData : GameData?
    var replayingPastGame = false
    var turnNo = 0
    var uiPic : [UIImage] = []
    var gameOver : Bool = false
    var speed: Double = 0.5
    var noSound : Bool = true
    var lastButton : Int = 0
    
    //MARK:- Labels / Images
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var buttonCtrl: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    
    //MARK:- Actions
    @IBAction func buttonStart(_ sender: UIButton) {
        initGame()
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        if whosTurn == GameUser.CPU {
            return
        }
        lastButton = sender.tag
        sender.isEnabled = false
        let idx = sender.tag
        theGameModel.user_AddSeq(idx)
        turnNo = theGameModel.user_Seq.count-1
        doOne(self.turnNo)
    }
    
    //MARK:- Observers
    var whosTurn: GameUser = GameUser.UNKNOWN {
        willSet(newTurn) {
            print("Whos Turn \(newTurn)")
        }
        didSet {
            if whosTurn != oldValue {
                gameLoop()
            }
        }
    }
    
    var animateToggle: Bool = false {
        willSet(newAnimate) {
            print("Animating \(newAnimate)")
        }
        didSet {
            if animateToggle != oldValue {
                // Set User.
                if whosTurn == GameUser.CPU {
                    whosTurn = GameUser.USER
                } else {
                    whosTurn = GameUser.CPU
                    if lastButton != 0 {
                        let tempButton = self.view.viewWithTag(Int(lastButton)) as? UIButton
                        tempButton?.isEnabled = true
                    }
                }
            }
        }
    }
    
    
    func evaluateUser() {
        
        if !theGameModel.compSequece() {
            gameOver1()
        } else {
            let uc = theGameModel.user_Seq.count
            let sc = theGameModel.simon_Seq.count
            print ("c: \(uc) - \(sc)")
            if sc == uc {
                // Round Passed.
                print("Seq Reached")
                animateToggle = !animateToggle
            } else {
                let tempButton = self.view.viewWithTag(Int(lastButton)) as? UIButton
                tempButton?.isEnabled = true
            }
        }
    }
    
    func gameLoop() {
    
        if (whosTurn == GameUser.CPU) {
            // Computer to Show Seq.
            displayNotice("Watch And Listen!")
            playSeq()
        }
        
        if (whosTurn == GameUser.USER) {
            displayNotice("Your Turn!")
            theGameModel.seqClearUser()
        }
        
    }
    
    
    func gameOver1() {
        displayNotice("GAME OVER!!")
        buttonCtrl.isHidden = false
        buttonCtrl.alpha = 1
        buttonCtrl.setTitle("Play Again", for: .normal)
        gameOver = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiPic.append(UIImage(named: "Empty")!)
        uiPic.append(UIImage(named: "Blue")!)
        uiPic.append(UIImage(named: "Yellow")!)
        uiPic.append(UIImage(named: "Green")!)
        uiPic.append(UIImage(named: "Red")!)

        button1.setBackgroundImage(uiPic[0], for: .normal)
        button2.setBackgroundImage(uiPic[0], for: .normal)
        button3.setBackgroundImage(uiPic[0], for: .normal)
        button4.setBackgroundImage(uiPic[0], for: .normal)
        
    }
    
    func initGame() {
        //Initalize Game
        theGameModel.seqClearAll()
        self.buttonCtrl.isHidden = true
        self.buttonCtrl.alpha = 0
        whosTurn = GameUser.CPU
    }
    
    func playSeq() {
        // Play Current Seq
        
        theGameModel.seqAddRnd()
        print("Play Seq Start")
        print(theGameModel.simon_Seq)
        turnNo = theGameModel.simon_Seq.count - 1
        doOne(0)
    }
    
    
    @objc func doOne(_ turn: Int) {
       
        var myTurn = turn
        
        if myTurn > turnNo {
            if whosTurn == GameUser.CPU {
                animateToggle = !animateToggle
            } else {
                evaluateUser()
            }
            return
        }
        
        var idx : Int = 0
        var img : UIImage
        if whosTurn == GameUser.CPU {
            idx = theGameModel.simon_Seq[myTurn]
            img  = uiPic[idx]
        } else {
            idx = theGameModel.user_Seq[myTurn]
            img = uiPic[idx]
        }

        switch idx {
        case 1:
            button1.setBackgroundImage(img, for: .normal)
        case 2:
            button2.setBackgroundImage(img, for: .normal)
        case 3:
            button3.setBackgroundImage(img, for: .normal)
        case 4:
            button4.setBackgroundImage(img, for: .normal)
        default:
            button1.setBackgroundImage(nil, for: .normal)
            button2.setBackgroundImage(nil, for: .normal)
            button3.setBackgroundImage(nil, for: .normal)
            button4.setBackgroundImage(nil, for: .normal)
        }
        
        if noSound {
            print("Sound!!!")
            self.audioPlayer.playSoundEffect("simonSound\(idx)")
        }
        
        let animationDuration = speed
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: {
        
            self.button1.setBackgroundImage(nil, for: .normal)
            self.button2.setBackgroundImage(nil, for: .normal)
            self.button3.setBackgroundImage(nil, for: .normal)
            self.button4.setBackgroundImage(nil, for: .normal)
            
            let animationDurationLast = self.speed / 4.0
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDurationLast, execute: {
                myTurn += 1
                self.doOne(myTurn)
            })
        })
        
    }
 
    
    func displayNotice(_ txt: String) {
        
        noticeLabel.text = txt
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
