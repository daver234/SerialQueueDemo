//
//  ViewController.swift
//  ConcurrencyDemo
//
//  Created by Hossam Ghareeb on 11/15/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//
//
//  Modified by Dave Rothschild May 29, 2016

import UIKit

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://algoos.com/wp-content/uploads/2015/08/ireland-02.jpg", "http://bdo.se/wp-content/uploads/2014/01/Stockholm1.jpg"]

class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {
        
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        return UIImage(data: data!)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // implementing serial displatch queues here
    //
    // app has one default serial queue which is main queue for the UI
    // 
    // need to create a new queue so not on main UI queue.
    //
    // In this approach, images are loaded in order, serial, one after another so not
    //  as fast as concurrent queue
    @IBAction func didClickOnStart(sender: AnyObject) {
        
        // create new serial queue
        let serialQueue = dispatch_queue_create("com.appcoda.imagesQueue", DISPATCH_QUEUE_SERIAL)
        
        
        dispatch_async(serialQueue) { () -> Void in
            
            let img1 = Downloader .downloadImageWithURL(imageURLs[0])
            dispatch_async(dispatch_get_main_queue(), {
                
                self.imageView1.image = img1
            })
            
        }
        dispatch_async(serialQueue) { () -> Void in
            
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.imageView2.image = img2
            })
            
        }
        dispatch_async(serialQueue) { () -> Void in
            
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.imageView3.image = img3
            })
            
        }
        dispatch_async(serialQueue) { () -> Void in
            
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.imageView4.image = img4
            })
        }
        
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        self.sliderValueLabel.text = "\(sender.value * 100.0)"
    }

}

