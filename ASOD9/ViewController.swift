//
//  ViewController.swift
//  ASOD9
//
//  Created by Maarten Brijker on 19/05/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startButton(sender: AnyObject) {
        
        // get user date
        // give date to get request
        performGetRequest()
    }
    
    func performGetRequest() {
        // https://api.nasa.gov/planetary/apod?api_key=oSbvqKOf8xqoqiakwOtFrwWUu2MEciFHTslA1u7f
        // apod? \(submitteddate) &api_key=
        
        let sourceUrl = "https://api.nasa.gov/planetary/apod?date=2016-05-18&api_key=oSbvqKOf8xqoqiakwOtFrwWUu2MEciFHTslA1u7f"
        let url = NSURL(string: sourceUrl)
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url!, completionHandler: {data, response, error in
            
            let responseStatusCode = (response as! NSHTTPURLResponse).statusCode
            print(responseStatusCode)
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                self.performSelectorOnMainThread(#selector(ViewController.gotoMovieDetails(_:)), withObject: json, waitUntilDone: true)

            } catch {
                print(error)
            }
        }).resume()
    }
    
    
    func gotoMovieDetails(json: NSDictionary) {
//        print("in gotoMovieDetails", json)
        self.performSegueWithIdentifier("HIT", sender: json)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print("segue.....", sender)
        let dataRequested = segue.destinationViewController as! ASODViewController
        dataRequested.NASADetails = sender! as? NSDictionary
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}