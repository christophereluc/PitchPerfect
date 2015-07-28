//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christopher Luc on 7/25/15.
//  Copyright (c) 2015 Christopher Luc. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    let vaderPitch = -1000 as Float
    let chipmunkPitch = 1000 as Float
    let fastRate = 1.5 as Float
    let slowRate = 0.5 as Float
    let normalRate = 1.0 as Float

    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    @IBAction func playFastSound(sender: UIButton) {
        playAudio(fastRate)
    }

    @IBAction func playSlowSound(sender: UIButton) {
        playAudio(slowRate)
    }
    @IBAction func stopAllAudio(sender: UIButton) {
        stopAllAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(chipmunkPitch)
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(vaderPitch)
    }
    
    //Function used to play audio with a variable pitch
    func playAudioWithVariablePitch(pitch: Float){
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    //Function used to play the audio at a variable speed
    func playAudio(speed: Float){
        stopAllAudio()
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    //Function used to stop the audioPlayer/audioEngine
    func stopAllAudio(){
        //Clear audio player
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = normalRate
        
        //Clear audio engine
        audioEngine.stop()
        audioEngine.reset()
    }
}
