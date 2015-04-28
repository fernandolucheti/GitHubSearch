//
//  Connection.swift
//  testView
//
//  Created by Guilherme Bayma on 4/28/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import UIKit

class Connection: UIView, NSURLConnectionDelegate {
    
    var data = NSMutableData()
    var arrayResponse = NSMutableArray()
    
    func connect(username: String, password: String, urlBusca: String) {
        // set up the base64-encoded credentials
        
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // create the request
        let url = NSURL(string: urlBusca)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let urlConnection = NSURLConnection(request: request, delegate: self)
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("Failed with error:\(error.localizedDescription)")
    }
    
    //NSURLConnection delegate method
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        //New request so we need to clear the data object
        self.data = NSMutableData()
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        //Append incoming data
        self.data.appendData(data)
        
        let json = JSON(data: self.data)
        for var i = 0; i < json.count; ++i{
            self.arrayResponse.addObject(json[i].object)
        }
    }
    
    //NSURLConnection delegate method
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        NSLog("connectionDidFinishLoading");
    }

}
