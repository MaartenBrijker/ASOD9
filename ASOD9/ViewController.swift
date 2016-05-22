//
//  ViewController.swift
//  ASOD9
//
//  Created by Maarten Brijker on 19/05/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var yearSubmit: UITextField!
    @IBOutlet weak var monthSubmit: UITextField!
    @IBOutlet weak var daySubmit: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Perform Get request with date, and segue to second screen.
    @IBAction func startButton(sender: AnyObject) {
        
        let year = Int(yearSubmit.text!)
        let month = Int(monthSubmit.text!)
        let day = Int(daySubmit.text!)
        
        performGetRequest(year!, month: month!, day: day!)
    }
    
    func performGetRequest(year: Int, month: Int, day: Int) {
        // https://api.nasa.gov/planetary/apod?api_key=oSbvqKOf8xqoqiakwOtFrwWUu2MEciFHTslA1u7f
        // apod? \(submitteddate) &api_key=
        
//        let sourceUrl = "https://api.nasa.gov/planetary/apod?date=2016-05-18&api_key=oSbvqKOf8xqoqiakwOtFrwWUu2MEciFHTslA1u7f"
        let sourceUrl = "https://api.nasa.gov/planetary/apod?date=\(year)-\(month)-\(day)&api_key=oSbvqKOf8xqoqiakwOtFrwWUu2MEciFHTslA1u7f"
        print(sourceUrl)
        let url = NSURL(string: sourceUrl)
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url!, completionHandler: {data, response, error in
            
            // Only perform get request when app is able to connect with internet.
            if (response != nil) {
                let responseStatusCode = (response as! NSHTTPURLResponse).statusCode
                print(responseStatusCode)
                
                if (responseStatusCode == 200) {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        self.performSelectorOnMainThread(#selector(ViewController.gotoMovieDetails(_:)), withObject: json, waitUntilDone: true)
                    } catch {
                        print(error)
                    }
                }
            } else if (response == nil) {
                print("you dont seem to have a working internet connection...")
            }
        }).resume()
    }
    
    func gotoMovieDetails(json: NSDictionary) {
        self.performSegueWithIdentifier("HIT", sender: json)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dataRequested = segue.destinationViewController as! ASODViewController
        dataRequested.NASADetails = sender as? NSDictionary
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}