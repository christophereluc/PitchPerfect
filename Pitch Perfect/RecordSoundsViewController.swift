//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christopher Luc on 7/25/15.
//  Copyright (c) 2015 Christopher Luc. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    let tapToStartLabel = "Tap to record"
    let recordingInProgressLabel = "Recording..."
    let errorLabel = "Error recording..."
    let fileName = "my_audio.wave"
    let stopSegueIdentifier = "stopRecording"
   
    override func viewWillAppear(animated: Bool) {
        resetScene(tapToStartLabel)
    }

    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        microphoneButton.enabled = false
        recordingLabel.text = recordingInProgressLabel
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let recordingName = fileName
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue, AVEncoderBitRateKey: 16, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0]
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            audioRecorder = try AVAudioRecorder(URL: filePath!, settings: recordSettings as! [String : AnyObject])
        } catch {
            print("could not set output to speaker")
        }
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setActive(false)
        }
        catch {
            print("Stop Failed")
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
                print("Error in audioRecorderDidFinishRecording")
            }
            self.performSegueWithIdentifier(stopSegueIdentifier, sender: recordedAudio)
        }
        else {
            resetScene(errorLabel)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == stopSegueIdentifier){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    //Used to reset the scene when view appears / error recording audio
    func resetScene(lable: String){
        microphoneButton.enabled = true
        stopButton.hidden = true
        recordingLabel.text = lable
    }
}

