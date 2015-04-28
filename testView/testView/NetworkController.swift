//
//  NetworkController.swift
//  GitHubSeach
//
//  Created by Fernando Lucheti on 27/04/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import Foundation
import UIKit

class NetworkController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func searchRepository(name:String) -> NSMutableArray?{
        var searchString: String = "https://api.github.com/users/\(name)/repos"
        var searchUrl = NSURL(string: searchString)!
        var searchData: NSData = NSData(contentsOfURL: searchUrl)!
        var repositories = NSMutableArray()
        let json = JSON(data: searchData)
        for var i = 0; i < json.count; ++i{
            repositories.addObject(json[i].object)
        }
        return repositories
    }
    
    func searchRepository() -> NSMutableArray?{
        var searchString: String = "https://api.github.com/users/mackmobile/repos"
        var searchUrl = NSURL(string: searchString)!
        var searchData: NSData = NSData(contentsOfURL: searchUrl)!
        var repositories = NSMutableArray()
        let json = JSON(data: searchData)
        for var i = 0; i < json.count; ++i{
            repositories.addObject(json[i].object)
        }
        return repositories
    }
    
    func searchForksURL() -> NSMutableArray{
        //https://api.github.com/repos/mackmobile/iDicionario/forks
        
        var repositories = searchRepository()
        var x = NSMutableArray()
        for var i = 0; i < repositories?.count; ++i{
            
            var fork = repositories?.objectAtIndex(i)["forks_url"] as! String
            x.addObject(fork)
            
        }
        return x
    }
    
//    func searchForkedRepositories(masterName: String, yourName: String) -> NSMutableArray{
//        
//       var forksURLS = searchForksURL()
//        
//        for var i = 0; i < forksURLS.count; ++i{
//        
//        }
//       
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}