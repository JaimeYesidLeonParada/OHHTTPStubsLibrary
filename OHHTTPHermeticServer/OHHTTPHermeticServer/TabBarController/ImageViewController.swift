//
//  ImageViewController.swift
//  OHHTTPHermeticServer
//
//  Created by Jaime Yesid Leon Parada on 9/23/15.
//  Copyright © 2015 JaimeLeon. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    
    @IBOutlet weak var spinner1: UIActivityIndicatorView!
    @IBOutlet weak var spinner2: UIActivityIndicatorView!
    @IBOutlet weak var spinner3: UIActivityIndicatorView!
    @IBOutlet weak var spinner4: UIActivityIndicatorView!
    @IBOutlet weak var spinner5: UIActivityIndicatorView!
    @IBOutlet weak var spinner6: UIActivityIndicatorView!
    
    var speedDownload : Double = DownloadSpeedWifi
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func dowloadImages(sender: AnyObject)
    {
        let urlMickey = NSURL(string: "http://images.clipartpanda.com/baby-mickey-mouse-clipart-black-and-white-4Tb4o8KGc.gif")
        let urlDonald = NSURL(string: "http://vignette4.wikia.nocookie.net/kingdomhearts/images/e/e6/Retro_Donald.png/revision/latest?cb=20131030025830")
        let urlDumbo = NSURL(string: "http://www.coloring-for-kids.net/wp-content/gallery/dumbo/coloriage-dumbo-5.gif")
        let urlGoofy = NSURL(string: "http://www.c1n3.org/GENEROS/DIBUJOS_ANIMADOS/goofy01/Images/1932%20Goofy%2001.jpg")
        let urlLilo = NSURL(string: "http://img11.deviantart.net/0a71/i/2007/336/f/e/lilo_and_stitch_by_fquihuis.jpg")
        let urlTimon = NSURL(string: "http://img10.deviantart.net/97f7/i/2009/026/a/7/timon___lion_king_by_golden_hill.jpg")
            
        self.spinner1.startAnimating()
        downloadImage(urlMickey!) { (image) -> Void in
            self.image1.image = image
            self.spinner1.stopAnimating()
        }
        
        self.spinner2.startAnimating()
        downloadImage(urlDonald!) { (image) -> Void in
            self.image2.image = image
            self.spinner2.stopAnimating()
        }
        
        self.spinner3.startAnimating()
        downloadImage(urlDumbo!) { (image) -> Void in
            self.image3.image = image
            self.spinner3.stopAnimating()
        }
        
        self.spinner4.startAnimating()
        downloadImage(urlGoofy!) { (image) -> Void in
            self.image4.image = image
            self.spinner4.stopAnimating()
        }
        
        self.spinner5.startAnimating()
        downloadImage(urlLilo!) { (image) -> Void in
            self.image5.image = image
            self.spinner5.stopAnimating()
        }
        
        self.spinner6.startAnimating()
        downloadImage(urlTimon!) { (image) -> Void in
            self.image6.image = image
            self.spinner6.stopAnimating()
        }
    }
    
    @IBAction func switchSpeedDownload(sender: UISwitch)
    {
        if sender.on
        {
            speedDownload = DownloadSpeedGPRS
        }
        else
        {
            self.speedDownload = DownloadSpeedWifi
        }
    }
    
    @IBAction func switchHermeticServer(sender: UISwitch)
    {
        if sender.on
        {
            let mickey : UIImage = UIImage(named: "mickey")!
            let donald : UIImage = UIImage(named: "donald")!
            let dumbo : UIImage = UIImage(named: "dumbo")!
            let goofy : UIImage = UIImage(named: "goofy")!
            let lilo : UIImage = UIImage(named: "lilo")!
            let timon : UIImage = UIImage(named: "timon")!
            
            OHHTTPManager.sharedInstance.startHermeticServerURLImage("http://images.clipartpanda.com/baby-mickey-mouse-clipart-black-and-white-4Tb4o8KGc.gif", image: mickey, downloadSpeed:speedDownload)
            
            OHHTTPManager.sharedInstance.startHermeticServerURLImage("http://vignette4.wikia.nocookie.net/kingdomhearts/images/e/e6/Retro_Donald.png/revision/latest?cb=20131030025830", image: donald, downloadSpeed:speedDownload)
            
            OHHTTPManager.sharedInstance.startHermeticServerURLImage("http://www.coloring-for-kids.net/wp-content/gallery/dumbo/coloriage-dumbo-5.gif", image: dumbo, downloadSpeed:speedDownload)
            
            OHHTTPManager.sharedInstance.startHermeticServerURLImage("http://www.c1n3.org/GENEROS/DIBUJOS_ANIMADOS/goofy01/Images/1932%20Goofy%2001.jpg", image: goofy, downloadSpeed:speedDownload)
            
            OHHTTPManager.sharedInstance.startHermeticServerURLImage("http://img11.deviantart.net/0a71/i/2007/336/f/e/lilo_and_stitch_by_fquihuis.jpg", image: lilo, downloadSpeed:speedDownload)
            
            OHHTTPManager.sharedInstance.startHermeticServerURLImage("http://img10.deviantart.net/97f7/i/2009/026/a/7/timon___lion_king_by_golden_hill.jpg", image: timon, downloadSpeed:speedDownload)
        }
        else
        {
            OHHTTPManager.sharedInstance.stop()
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
    
    func getDataFromURL(url:NSURL, completion:((NSData?) -> Void))
    {
        NSURLSession.sharedSession().dataTaskWithURL(url)
            {
                (data, response, error) in completion (data)
            }.resume()
    }

}
