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
    
    
    
    func searchRepository() -> NSMutableArray {
        //usuario e senha git
        let username = ""
        let password = ""
        
        let conn = Connection()
        conn.connect(username, password: password, urlBusca: "https://api.github.com/users/mackmobile/repos")
        
        return conn.arrayResponse
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}