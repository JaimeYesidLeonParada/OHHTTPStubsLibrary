//
//  RequestDownload.swift
//  OHHTTPHermeticServer
//
//  Created by Jaime Yesid Leon Parada on 9/23/15.
//  Copyright © 2015 JaimeLeon. All rights reserved.
//

import Foundation
import UIKit

public class RequestDownload: NSObject
{
    public func downloadImage(url:NSURL, completion:(UIImage?) -> Void){
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