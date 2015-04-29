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
    let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func searchRepository() -> NSMutableArray {
        
        let conn = Connection()
        let array = conn.connect(user.username, password: user.password, urlBusca: "https://api.github.com/users/\(user.username)/repos")
        
        //println("\(array)")
        
        
        
        var arrayRepos = NSMutableArray()
        
        for var i=0; i < array.count; i++ {
            let urlRepo = array[i]["url"] as! String
            let conRepo = conn.connectOne(user.username, password: user.password, urlBusca: urlRepo)
            
            if let parent: AnyObject = conRepo["parent"] {
                //println("\(parent)")
                if let owner: AnyObject = parent["owner"] {
                    //println("\(owner)")
                    if let login: AnyObject = owner["login"] {
                        if login as! String == "mackmobile" {
                            arrayRepos.addObject(conRepo)
                        }
                    }
                }
            }
        }
        
        
        
        
        return arrayRepos
        
        
    }
    
    
    
    
}