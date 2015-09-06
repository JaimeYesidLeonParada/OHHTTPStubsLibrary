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
    private func startHermeticServer(url:String, endPoint:String ,data:NSData)
    {
        OHHTTPStubs.stubRequestsPassingTest({(request: NSURLRequest!) in
            
            if !(endPoint.isEmpty)
            {
                let predicateValide = self.predicateWithEndPoint(endPoint, request: request) as Bool
                return (predicateValide == true) ? true : false
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
    
    //MARK:URL---
    func startHermeticServerURLData(url:String, data:NSData)
    {
        self.startHermeticServer(url, endPoint: "",data: data)
    }
    
    func startHermeticServerURLString(url:String, string:String)
    {
        let data : NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        self.startHermeticServer(url, endPoint: "", data: data)
    }
    
    func startHermeticServerURLImage(url:String, image:UIImage)
    {
        let data : NSData = UIImageJPEGRepresentation(image, 1.0)!
        self.startHermeticServer(url, endPoint: "",data: data)
    }
    
    //MARK:URL---
    private func startHermeticServerJSON(url:String, endPoint:String, containsURL:String, pathForFile:String, statusCode: Int32)
    {
        OHHTTPStubs.stubRequestsPassingTest({(request: NSURLRequest!) in
            
            if !(endPoint.isEmpty)
            {
                let predicateValide = self.predicateWithEndPoint(endPoint, request: request) as Bool
                return (predicateValide == true) ? true : false
            }
            else if !(containsURL.isEmpty)
            {
                let predicateValide = self.predicateWithURLContains(containsURL, request: request) as Bool
                return (predicateValide == true) ? true : false
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
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: statusCode, headers: ["Content-Type":"application/json"])
        })
    }
    
    func startHermeticServerJSONWithURL(url:String, pathForFile:String, statusCode:Int32)
    {
        self.startHermeticServerJSON(url, endPoint: "", containsURL: "", pathForFile: pathForFile, statusCode: statusCode)
    }
    
    func startHermeticServerJSONWithEndpoint(endPoint:String, pathForFile:String, statusCode:Int32)
    {
        self.startHermeticServerJSON("", endPoint: endPoint, containsURL: "", pathForFile: pathForFile, statusCode: statusCode)
    }
    
    func startHermeticServerJSONWithContainsURL(containsURL:String, pathForFile:String, statusCode:Int32)
    {
        self.startHermeticServerJSON("", endPoint: "", containsURL: containsURL, pathForFile: pathForFile, statusCode: statusCode)
    }
    
    
    private func predicateWithEndPoint(endPoint:String , request:NSURLRequest) -> Bool
    {
        let predicate = NSPredicate(format: "SELF ENDSWITH %@", endPoint)
        return predicate.evaluateWithObject(request.URL!.relativePath!) as Bool
    }
    
    private func predicateWithURLContains(containsURL:String , request:NSURLRequest) -> Bool
    {
        let predicate = NSPredicate(format: "SELF CONTAINS %@", containsURL)
        return predicate.evaluateWithObject(request.URL!.absoluteString) as Bool
    }
    
}


