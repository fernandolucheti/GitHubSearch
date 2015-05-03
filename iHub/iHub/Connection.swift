//
//  Connection.swift
//  testView
//
//  Created by Guilherme Bayma on 4/28/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import UIKit

class Connection: UIView, NSURLConnectionDelegate {
    
    func connect(username: String, password: String, urlBusca: String) -> NSMutableArray {
        // set up the base64-encoded credentials
        
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // create the request
        let url = NSURL(string: urlBusca)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        var response: NSURLResponse?
        var error: NSError?
        
        var arrayResponse = NSMutableArray()
        
        //let urlConnection = NSURLConnection(request: request, delegate: self)
        let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        if let dataURL = urlData as NSData! {
            let json = JSON(data: dataURL)
            for var i = 0; i < json.count; ++i{
                arrayResponse.addObject(json[i].object)
            }
        }
        return arrayResponse
    }
    
    func connectOne(username: String, password: String, urlBusca: String) -> NSDictionary {
        // set up the base64-encoded credentials
        
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // create the request
        let url = NSURL(string: urlBusca)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        var response: NSURLResponse?
        var error: NSError?
        
        let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error) as NSData!
        let json = JSON(data: urlData)
        
        return json.object as! NSDictionary
    }


}
