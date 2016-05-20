//
//  ViewController.swift
//  ASOD9
//
//  Created by Maarten Brijker on 19/05/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
   
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
//                let title = json["title"]
//                let explanation = json["explanation"]
                let imageURL = json["url"] as! String

                let webURL = NSURL(string: imageURL)
                
//                print(webURL)
                self.downloadImage(webURL!)
            
            } catch {
                print(error)
            }
        }).resume()
    
       

    
    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    

    
    

}

