//
//  OHHTTPManager.swift
//  OHHTTPHermeticServer
//
//  Created by MACBOOK on 30/08/15.
//  Copyright © 2015 JaimeLeon. All rights reserved.
//

import UIKit
import OHHTTPStubs

public enum DownloadSpeed  : Double {
    case DownloadSpeedGPRS =    -7
    case DownloadSpeedEDGE =    -16
    case DownloadSpeed3G =      -400
    case DownloadSpeed3GPlus =  -900
    case DownloadSpeedWifi =    -1500
}

class OHHTTPManager: NSObject {
    
    static let sharedInstance = OHHTTPManager()
    
    //MARK:Setup---
    
    func start()
    {
        OHHTTPStubs.setEnabled(true)
        
        
        var configurationHermetic: NSDictionary?
        
        let path = NSBundle.mainBundle().pathForResource("ConfigurationHermetic", ofType: "plist")
        
        configurationHermetic = NSDictionary(contentsOfFile: path!)
        
        print("Configuration: \(configurationHermetic)");
            
        
        
        
    }
    
    func stop()
    {
        OHHTTPStubs.removeAllStubs()
    }
    
    //MARK:Private General Hermetic---
    private func startHermeticServer(url:String, endPoint:String ,data:NSData, requestTime:DownloadSpeed)
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
                
                return OHHTTPStubsResponse(data: data, statusCode:200, headers:nil).responseTime(requestTime.rawValue)
        })
    }
    
    //MARK:URL---
    func startHermeticServerURLData(url:String, data:NSData ,requestTime:DownloadSpeed)
    {
        self.startHermeticServer(url, endPoint: "",data: data, requestTime:requestTime)
    }
    
    func startHermeticServerURLString(url:String, string:String ,requestTime:DownloadSpeed)
    {
        let data : NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        self.startHermeticServer(url, endPoint: "", data: data, requestTime:requestTime)
    }
    
    func startHermeticServerURLImage(url:String, image:UIImage ,requestTime:DownloadSpeed)
    {
        let data : NSData = UIImageJPEGRepresentation(image, 1.0)!
        self.startHermeticServer(url, endPoint: "",data: data , requestTime:requestTime)
    }
    
    //MARK:URL---
    private func startHermeticServerJSON(url:String, endPoint:String, containsURL:String, pathForFile:String, statusCode: Int32, requestTime:DownloadSpeed)
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
                return OHHTTPStubsResponse(fileAtPath: stubPath!, statusCode: statusCode, headers: ["Content-Type":"application/json"]).responseTime(requestTime.rawValue)
        })
    }
    
    func startHermeticServerJSONWithURL(url:String, pathForFile:String, statusCode:Int32, requestTime:DownloadSpeed)
    {
        self.startHermeticServerJSON(url, endPoint: "", containsURL: "", pathForFile: pathForFile, statusCode: statusCode, requestTime:requestTime)
    }
    
    func startHermeticServerJSONWithEndpoint(endPoint:String, pathForFile:String, statusCode:Int32, requestTime:DownloadSpeed)
    {
        self.startHermeticServerJSON("", endPoint: endPoint, containsURL: "", pathForFile: pathForFile, statusCode: statusCode, requestTime:requestTime)
    }
    
    func startHermeticServerJSONWithContainsURL(containsURL:String, pathForFile:String, statusCode:Int32, requestTime:DownloadSpeed)
    {
        self.startHermeticServerJSON("", endPoint: "", containsURL: containsURL, pathForFile: pathForFile, statusCode: statusCode, requestTime:requestTime)
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


