//
//  Robert_GameViewController.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-03-28.
//
import Foundation
import UIKit
import AVFoundation

class Robert_GameViewController: UIViewController {

    //MARK: Enumerations
    enum GameUser {
        case CPU, USER , REPLAY, UNKNOWN
    }
    
    //MARK: Class var.
    
    var theGameModel = Robert_MySimonGameModel()
    var audioPlayer = Robert_Audio()
    
    //var gameFinished = false
    var pastGameData : GameData?
    var replayingPastGame = false
    var tempTurnCounter = 0
    var currButtonSelectTag : Int = 0
    
    var isGameOver : Bool = false
    
    var settingSpeed: Double = 0.5
    var settingPlaySound : Bool = false
    var settingSoundSet : String = ""
    var buttons: [UIButton] = [UIButton]()
    
    //MARK: Labels, Images
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var buttonCtrl: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
        
    //MARK: Actions
    // Start / Play Again
    @IBAction func buttonStart(_ sender: UIButton) {
        initGame()
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        if whosTurn == GameUser.CPU || isGameOver {
            return
        }
        currButtonSelectTag = sender.tag
        tempTurnCounter = 0
        amineOneTurn(0)
    }
    
    //MARK: Observers
    
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
                    theGameModel.userTurnPointer = 0
                    whosTurn = GameUser.CPU
                }
            }
        }
    }
    
    //MARK: Game Start
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1st one just a placeholder
        self.buttons = [button1,button1,button2,button3,button4]
        // Buttons Not Clickable (Yet)
        for b in buttons {
            b.isEnabled = false
            b.alpha = 0.0101
        }

        settingSpeed = Double(UserDefaults.standard.float(forKey: Constants.SLIDER) / 10)
        if settingSpeed == 0.0  {
            UserDefaults.standard.set(5, forKey: Constants.SLIDER)
            UserDefaults.standard.set(true, forKey: Constants.AUDIOBOOL)
            UserDefaults.standard.set(0, forKey: Constants.AUDIOSET)
            settingSpeed = 0.5
        }
        
        settingPlaySound = UserDefaults.standard.bool(forKey: Constants.AUDIOBOOL)
        
        let soundSelect : Int = UserDefaults.standard.integer(forKey: Constants.AUDIOSET)
        settingSoundSet = SoundValues.listOfSounds[soundSelect]
        
        if (replayingPastGame) {
            theGameModel.isPastGame = true
            replayGame()
        } else {
            theGameModel.isPastGame = false
        }
    }
    
    func initGame() {
        //Initalize Game
        print("----------------------[ New Game]")
        theGameModel.seqClearAll()
        self.buttonCtrl.isHidden = true
        self.buttonCtrl.alpha = 0
        isGameOver = false
        whosTurn = GameUser.CPU
    }
    
    func gameLoop() {
    
        if (whosTurn == GameUser.CPU) {
            // Computer to Show Seq.
            cpuTurn()
        }
        
        if (whosTurn == GameUser.USER) {
            for b in buttons {
                b.isEnabled = true
            }
            let currTurn = theGameModel.getTurn()
            displayNotice("Your Turn " + String(currTurn))
        }
        
    }
    
    
    //MARK: User, CPU Turns & Replay
    
    func userTurn() {
        if isGameOver {
            return
        }
        print(">> Current \(currButtonSelectTag)")
        if !theGameModel.compSeq(currButtonSelectTag) {
            gameOver()
        } else {
            print(">> UT \(theGameModel.userTurnPointer)")
            let sc = theGameModel.simon_Seq.count - 1
            //theGameModel.userTurnPointer += 1
            let uc = theGameModel.userTurnPointer
            if sc == uc {
                // Round Passed.
                print("Seq Reached")
                animateToggle = !animateToggle
                return
            }
            theGameModel.userTurnPointer += 1
        }
    }
    
    func cpuTurn() {
        // Play Current Seq
        tempTurnCounter = 0
        theGameModel.seqAddRnd()
        print(theGameModel.simon_Seq)
        theGameModel.addTurn()
        let currTurn = theGameModel.getTurn()
        print("Play Seq Start "+String(currTurn))
        displayNotice("Watch And Listen! Turn : " + String(currTurn))
        tempTurnCounter = currTurn-1
        sleep(1)
        amineOneTurn(0)
    }
    
    func replayGame() {
        theGameModel.seqClearAll()
        self.buttonCtrl.isHidden = true
        self.buttonCtrl.alpha = 0
        isGameOver = false
        let pastGameMoves = (pastGameData?.orderOfMoves)!
        navigationItem.title = "Past Game"
        displayNotice("Replaying Game")
        theGameModel.simon_AddSeqString(pastGameMoves)
        whosTurn = GameUser.REPLAY
        let currTurn = theGameModel.getTurn()
        tempTurnCounter = currTurn-1
        amineOneTurn(0)
    }
    
    //MARK: Game Over
    
    func gameOver() {
        let currTurn = theGameModel.getTurn()
        theGameModel.saveGame()
        displayNotice("GAME OVER!!" + String(currTurn))
        let playEnd : String = settingSoundSet+"E"
        if settingPlaySound {
            print("Over Sound!!!")
            //DispatchQueue.global(qos: .background).async {
                self.audioPlayer.playSoundEffect(playEnd)
            //}
        }
        buttonCtrl.isHidden = false
        buttonCtrl.alpha = 1
        buttonCtrl.setTitle("Play Again", for: .normal)
        isGameOver = true
    }
    

    //MARK: Recursive Graphics Component
    
    @objc func amineOneTurn(_ turn: Int) {
        
        var myTurn : Int = turn
        
        if myTurn > tempTurnCounter {
            if whosTurn == GameUser.CPU {
                animateToggle = !animateToggle
                return
            }
            if whosTurn == GameUser.USER {
                userTurn()
                return
            }
            if whosTurn == GameUser.REPLAY {
                gameOver()
                return
            }
        }
        
        var idx : Int = 0
        //var img : UIImage
        if whosTurn == GameUser.CPU || whosTurn == GameUser.REPLAY {
            idx = theGameModel.simon_Seq[myTurn]
        } else {
            idx = currButtonSelectTag
        }

        if settingPlaySound {
            self.audioPlayer.playSoundEffect(settingSoundSet + String(idx))
        }
    
        //MARK: ANIMATION.
        //Make White Button Image Pop and Viewable
        buttons[idx].alpha = 1
        //And then Fade.
        UIView.animate(withDuration: settingSpeed, delay: 0.0,
                       animations: {self.buttons[idx].alpha = 0.101},
                       completion: {(finished:Bool) in
                            myTurn += 1
                            self.amineOneTurn(myTurn)})
    }
 
    //MARK: Display Utility.
    
    //display on screen
    func displayNotice(_ txt: String) {
        noticeLabel.text = txt
    }
    
    //function to test process speed
    func displayTime() -> String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .full
        let dt = dateFormatter.string(from: nowDate)
        return dt
    }
    
}
