//
//  ViewController.swift
//  OHHTTPHermeticServer
//
//  Created by MACBOOK on 30/08/15.
//  Copyright © 2015 JaimeLeon. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //OHHTTPManager.sharedInstance.start()
        
        //OHHTTPManager.sharedInstance.startHermeticServerString("2.bp.blogspot.com", string: "Donald Duck")
        
        //let mickey : UIImage = UIImage(named: "Mickey")!
        
        /*
        OHHTTPManager.sharedInstance.startHermeticServerURLImage("http://2.bp.blogspot.com/-rZCJctudjVc/T744Uxgi4gI/AAAAAAAAA8o/PPF2lIoZ4EU/s1600/disney~donaldduck~danetta.png", image: mickey)
        */
        //OHHTTPManager.sharedInstance.startHermeticServerJSON("", url: "", endPoint:"q=Toy+Story+3",pathForFile: "Incredibles.json")
        
        OHHTTPManager.sharedInstance.startHermeticServerJSONWithContainsURL("q=Toy+Story+3", pathForFile: "Incredibles.json", statusCode: 200)
        OHHTTPManager.sharedInstance.startHermeticServerJSONWithContainsURL("q=Aladin", pathForFile: "Tomorrowland.json", statusCode: 200)
        
        
       // OHHTTPManager.sharedInstance.startHermeticServerURLImage("http://2.bp.blogspot.com/-rZCJctudjVc/T744Uxgi4gI/AAAAAAAAA8o/PPF2lIoZ4EU/s1600/disney~donaldduck~danetta.png", image: mickey)
        
    }
    
    
    @IBAction func downloadButton(sender: AnyObject) {
        
        /*
        let url = NSURL(string: "http://2.bp.blogspot.com/-rZCJctudjVc/T744Uxgi4gI/AAAAAAAAA8o/PPF2lIoZ4EU/s1600/disney~donaldduck~danetta.png")
        
        downloadImage(url!) { (image) -> Void in
            self.imageView.image = image
        }
        */
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=74n8r9ntbuur8j6safugwanp&q=Toy+Story+3")!)
        httpGet(request){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(data)
            }
        }
    }
    @IBAction func downloadTomorroland(sender: AnyObject) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=74n8r9ntbuur8j6safugwanp&q=Aladin")!)
        httpGet(request){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(data)
            }
        }
        
    }
    
    func downloadImage(url:NSURL, completion:(UIImage?) -> Void){
        getDataFromURL(url)
            { data in
                dispatch_async(dispatch_get_main_queue())
                    {
                        completion(UIImage(data: data!))
                }
        }
    }
    
    func downloadText(url:NSURL, completion:(NSString?) -> Void){
        getDataFromURL(url)
            { data in
                dispatch_async(dispatch_get_main_queue())
                    {
                        completion(NSString(data: data!, encoding: NSUTF8StringEncoding))
                }
        }
    }
    
    func getDataFromURL(url:NSURL, completion:((NSData?) -> Void))
    {
        NSURLSession.sharedSession().dataTaskWithURL(url)
            {
                (data, response, error) in completion (data)
            }.resume()
    }
    
    func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding:
                    NSASCIIStringEncoding)!
                callback(result as String, nil)
            }
        }
        task.resume()
    }


}

