//
//  OHHTTPManager.swift
//  OHHTTPHermeticServer
//
//  Created by MACBOOK on 30/08/15.
//  Copyright © 2015 JaimeLeon. All rights reserved.
//

import UIKit
import OHHTTPStubs

class OHHTTPManager: NSObject {
    
    
    static let sharedInstance = OHHTTPManager()
    
    //MARK:Setup---
    
    func start()
    {
        OHHTTPStubs.setEnabled(true)
    }
    
    func stop()
    {
        OHHTTPStubs.removeAllStubs()
    }
    
    //MARK:Private General Hermetic---
    private func startHermeticServer(host:String, url:String, endPoint:String ,data:NSData)
    {
        OHHTTPStubs.stubRequestsPassingTest({(request: NSURLRequest!) in
            
            if !(endPoint.isEmpty)
            {
                return self.predicateWithEndPoint(endPoint, request: request)
            }
            
            if !(host.isEmpty)
            {
                return request.URL!.host == host ? true : false
            }
            else if !(url.isEmpty)
            {
                return request.URL! == (NSURL(string:url)) ? true : false
            }
            else
            {
                return false
            }
            
            }, withStubResponse: { _ in
                
                return OHHTTPStubsResponse(data: data, statusCode:200, headers:nil)
        })
    }
    
    //MARK:Host---
    func startHermeticServerHostData(host:String, data:NSData)
    {
        self.startHermeticServer(host, url: "", endPoint: "", data: data)
    }
    
    func startHermeticServerHostString(host:String, string:String)
    {
        let data : NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        self.startHermeticServer(host, url: "", endPoint: "", data: data)
    }
    
    func startHermeticServerHostImage(host:String, image:UIImage)
    {
        let data : NSData = UIImageJPEGRepresentation(image, 1.0)!
        self.startHermeticServer(host, url: "", endPoint: "",data: data)
    }
    
    //MARK:URL---
    func startHermeticServerURLData(url:String, data:NSData)
    {
        self.startHermeticServer("", url: url, endPoint: "",data: data)
    }
    
    func startHermeticServerURLString(url:String, string:String)
    {
        let data : NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        self.startHermeticServer("", url: url, endPoint: "", data: data)
    }
    
    func startHermeticServerURLImage(url:String, image:UIImage)
    {
        let data : NSData = UIImageJPEGRepresentation(image, 1.0)!
        self.startHermeticServer("", url: url, endPoint: "",data: data)
    }
    
    //MARK:URL---
    func startHermeticServerJSON(host:String, url:String, endPoint:String, pathForFile:String)
    {
        OHHTTPStubs.stubRequestsPassingTest({(request: NSURLRequest!) in
            
            if !(endPoint.isEmpty)
            {
                return self.predicateWithEndPoint(endPoint, request: request)
            }
            
            if !(host.isEmpty)
            {
                return request.URL!.host == host ? true : false
            }
            else if !(url.isEmpty)
            {
                return request.URL! == (NSURL(string:url)) ? true : false
            }
            else
            {
                return false
            }
            
            }, withStubResponse: { _ in
                let stubPath = OHPathForFile(pathForFile, self.dynamicType)
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
    }
    
    
    func predicateWithEndPoint(endPoint:String , request:NSURLRequest) -> Bool
    {
        let predicate = NSPredicate(format: "SELF ENDSWITH %@", endPoint)
        return predicate.evaluateWithObject(request.URL!.relativePath!) as Bool
    }
    
}


