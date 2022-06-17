//
//  Robert_Audio.swift
//  Robert_Betttinelli_MySimon
//
//  Created by ROBERT BETTINELLI on 2022-03-29.
//

import UIKit
import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?
var noError: Bool = true

class Robert_Audio {
    
    func playSoundEffect(_ assetName:String) {
        
        guard let audioData = NSDataAsset(name: assetName)?.data else {
                fatalError("Unable to find asset \(assetName)")
        }
            
        do {
                
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                options: AVAudioSession.CategoryOptions.mixWithOthers
            )
            
            try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVAudioPlayer(data: audioData)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                if noError {
                    print(error.localizedDescription)
                }
        }
        //audioPlayer?.stop()
        
    }
    
    func stopPlay() {
        audioPlayer?.setVolume(0.0, fadeDuration: 0.25)
    }
    
}
