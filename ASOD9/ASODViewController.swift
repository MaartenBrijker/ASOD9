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

    // Variable to get json data from segue.
    var NASADetails: NSDictionary?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (NASADetails != nil) {
            print("IN HEREEEEEE")
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
    
    func startSpeech(theSpeech: String) {
        let utterance = AVSpeechUtterance(string: theSpeech)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-IR")
        utterance.rate = 0.4
        utterance.pitchMultiplier = 2.0
        utterance.volume = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }
}
