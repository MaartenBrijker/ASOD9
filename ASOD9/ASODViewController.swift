//
//  ASODViewController.swift
//  ASOD9
//
//  Created by Maarten Brijker on 19/05/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit
import AudioKit
import AVFoundation

class ASODViewController: UIViewController {

    // Initializing all the audio kits.
    var oscillator = AKTriangleOscillator()
    var player: AKAudioPlayer?
    var player2: AKAudioPlayer?
    var reverb: AKReverb2?
    var mixer = AKMixer()
    var drywetmixer = AKDryWetMixer?()
    var filter: AKToneFilter?
    var filter2: AKMoogLadder?
    var reverb3: AKReverb?
    var delay: AKDelay?
    let file = NSBundle.mainBundle().pathForResource("RFX6", ofType: "WAV")
    let file2 = NSBundle.mainBundle().pathForResource("akonalien", ofType: "mp3")
    
    // Variable to get json data from segue.
    var NASADetails: NSDictionary?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (NASADetails != nil) {
            setupAudio()
            let imageURL = NASADetails!["url"] as! String
            let webURL = NSURL(string: imageURL)
            print("WEB URL =", webURL!)
            downloadImage(webURL!)
            titleLable.text = NASADetails!["title"] as? String
            let theSpeech = NASADetails!["explanation"] as! String
            startSpeech(theSpeech)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: - Get data and download image + info.

    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.imageView!.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
// MARK: - Soundcontrol
    
    /// Seting up players for 2 audiofiles, oscillator, all into mixer and through effects.
    func setupAudio() {
        player = AKAudioPlayer(file!)
        player2 = AKAudioPlayer(file2!)
        filter = AKToneFilter(player!)
        player?.looping = true
        filter2 = AKMoogLadder(player2!)
        reverb3 = AKReverb(filter2!)
        mixer.connect(reverb3!)
        mixer.connect(filter!)
        mixer.connect(oscillator)
        reverb = AKReverb2(mixer)
        let squareWave = AKSquareWaveOscillator()
        drywetmixer = AKDryWetMixer(reverb!, squareWave, balance: 0.5)
        delay = AKDelay(drywetmixer!)
        player?.looping = true
        player2?.looping = true
        AudioKit.output = delay
        AudioKit.start()
    }
    
    @IBAction func playAlienSound(sender: AnyObject) {
        if player2?.isPlaying == true {
            player2?.stop()
        } else {
            player2?.start()
        }
    }
    
    @IBAction func playBleepSound(sender: AnyObject) {
        if player?.isPlaying == true {
            player?.stop()
        } else {
            player?.start()
        }
    }
    
    /// Start osc, and change tones after it gets tapped again.
    @IBAction func toggleOscillator(sender: AnyObject) {
        if oscillator.isPlaying {
            oscillator.stop()
        } else {
            oscillator.amplitude = random(0, 1)
            oscillator.detuningMultiplier = random(0, 3)
            oscillator.detuningOffset = random(0, 1)
            oscillator.frequency = random(220, 880)
            oscillator.start()
        }
    }
    
    @IBAction func changeAmountOfReverb(sender: AnyObject) {
        drywetmixer?.balance = random(0, 1)
    }
    
    /// Start explanation text to speech converting and reading.
    func startSpeech(theSpeech: String) {
        let utterance = AVSpeechUtterance(string: theSpeech)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-IR")
        utterance.rate = 0.4
        utterance.pitchMultiplier = 2.0
        utterance.volume = 0.6
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }
    
    @IBOutlet weak var filterSlider: UISlider!
    /// Filter slider, filters between the Bleep and Alien sounds.
    @IBAction func filtering(sender: AnyObject) {
        let avalue = Double(filterSlider.value)
        let inverseValue = 2000 - avalue
        filter?.halfPowerPoint = avalue
        filter2?.cutoffFrequency = inverseValue
    }
    
    @IBOutlet weak var feedbacklevel: UISlider!
    /// Handles feebdack level of delay.
    @IBAction func feedbacking(sender: AnyObject) {
        let fback = feedbacklevel.value
        delay?.feedback = Double(fback)
    }

    
    
}
