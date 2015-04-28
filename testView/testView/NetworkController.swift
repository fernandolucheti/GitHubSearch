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
        conn.connect(user.username, password: user.password, urlBusca: "https://api.github.com/users/fernandolucheti/repos")
        return conn.arrayResponse
    }
    
    func searchForkedRepositories(masterName: String, yourName: String){
        let connection = Connection()
        
        connection.connect(user.username, password: user.password, urlBusca: "https://api.github.com/users/fernandolucheti/repos")
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}