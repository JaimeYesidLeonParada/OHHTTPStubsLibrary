//
//  JsonViewController.swift
//  OHHTTPHermeticServer
//
//  Created by Jaime Yesid Leon Parada on 9/23/15.
//  Copyright © 2015 JaimeLeon. All rights reserved.
//

import UIKit

class JsonViewController: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var movies : NSArray! = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    //MARK:Actions---
    
    @IBAction func switchHermeticServer(sender: UISwitch)
    {
        if (sender.on)
        {
            OHHTTPManager.sharedInstance.start()
        }
        else
        {
            OHHTTPManager.sharedInstance.stop()
        }
    }
    
    
    @IBAction func searchMovies(sender: UIButton)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=74n8r9ntbuur8j6safugwanp&q=Disney")!)
        
        self.movies = []
        self.tableView.reloadData()
        
        httpGet(request){
            (data, error1) -> Void in
            if error1 != nil
            {
                print(error1)
            } else
            {
                do
                {
                    let jsonDict : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    self.movies = jsonDict.objectForKey("movies") as! NSArray
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                    
                    //self.tableView.reloadData()
                    print("dictionary: \(self.movies)")
                }
                catch
                {
                    print("json error: \(error)")
                }
            }
        }
    }
    
    
    //MARK:TableView DataSource---
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.movies.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 95
    }
    
    //MARK:TableView Delegate---
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")!
        
        let valueDict : NSDictionary = self.movies[indexPath.row] as! NSDictionary
        
        cell.textLabel?.text = (valueDict.objectForKey("title") as! String)
        
        let posters : NSDictionary = valueDict.objectForKey("posters") as! NSDictionary
        
        let urlThumbnail = NSURL(string: posters.objectForKey("thumbnail") as! String)
        
        downloadImage(urlThumbnail!) { (imagePoster) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.imageView?.image = imagePoster
                cell.setNeedsLayout()
            })
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK:Request---
    func httpGet(request: NSURLRequest!, callback: (NSData, String?) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil
            {
                callback(NSData.init(), error!.localizedDescription)
            } else {
                callback(data!, nil)
            }
        }
        task.resume()
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
    
    func getDataFromURL(url:NSURL, completion:((NSData?) -> Void))
    {
        NSURLSession.sharedSession().dataTaskWithURL(url)
            {
                (data, response, error) in completion (data)
            }.resume()
    }
}
