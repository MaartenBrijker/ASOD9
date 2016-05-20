//
//  ASODViewController.swift
//  ASOD9
//
//  Created by Maarten Brijker on 19/05/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit

class ASODViewController: UIViewController {

    // Variable to get json data from segue.
    var NASADetails: NSDictionary?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let webURL = NSURL(string: "http://apod.nasa.gov/apod/image/1605/halo_pano_beletsky.jpg")
//        downloadImage(webURL!)
        
        print("NASADetails =====", NASADetails)
        
        titleLable.text = "waarom laat je dit definitief zien?"
        
        if (NASADetails != nil) {
            
            print("IN HEREEEEEE")
        
            let imageURL = NASADetails!["url"] as! String
            let webURL = NSURL(string: imageURL)
            
            print("         WEB URL =", webURL!)
            
            downloadImage(webURL!)
            
            let title = NASADetails!["title"]
            print("title ===== ", title)
            
            titleLable.text = "waarom vervangt het textlabel niet?"
            
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
}
