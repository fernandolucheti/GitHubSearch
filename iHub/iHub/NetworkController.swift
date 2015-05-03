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
    var yourRepos = NSMutableArray()
    
    func searchRepository() -> NSMutableArray {
        let conn = Connection()
        let array = self.searchYourRepo()
        
        var arrayRepos = NSMutableArray()
        
        for var i=0; i < array.count; i++ {
            let urlRepo = array[i]["url"] as! String
            let conRepo = conn.connectOne(user.username, password: user.password, urlBusca: urlRepo)
            
            if let parent: AnyObject = conRepo["parent"] {
                if let owner: AnyObject = parent["owner"] {
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
    
    func persistRepositories(){
        RepositoryManager.sharedInstance.removeAll()
        for var i = 0; i < yourRepos.count; ++i{
            var repo = RepositoryManager.sharedInstance.newRepository()
            repo.name = yourRepos.objectAtIndex(i)["name"] as! String
            repo.forked = 0
            var x: AnyObject = yourRepos.objectAtIndex(i)
            if let fork: AnyObject = yourRepos.objectAtIndex(i)["fork"] as? Int{
                if fork as! NSNumber == 0{
                    repo.forked = 0
                }else{
                    repo.forked = 1
                }
            }
            RepositoryManager.sharedInstance.save()
        }
    }
    
    func searchCommits(nameRepo: String) -> NSMutableArray{
        let conn = Connection()
        let array = conn.connect(user.username, password: user.password, urlBusca: "https://api.github.com/repos/\(user.username)/\(nameRepo)/commits")
        return array;
    }
    
    func searchYourRepo() -> NSMutableArray{
        let conn = Connection()
        yourRepos = conn.connect(user.username, password: user.password, urlBusca: "https://api.github.com/users/\(user.username)/repos")
        persistRepositories()
        return yourRepos;
    }
    
    func searchBadges(nomeRepo: String) -> NSMutableArray{
        let conn = Connection()
        var page = 1
        var arrayCompleto = NSMutableArray()
        var array = NSMutableArray()
        var badges = NSMutableArray()
        do {
            let url = "https://api.github.com/repos/mackmobile/\(nomeRepo)/pulls?state=all&page=\(page)"
            array = conn.connect(user.username, password: user.password, urlBusca: url)
            arrayCompleto.addObjectsFromArray(array as [AnyObject])
            page++
        } while array.count != 0
        
        var number = -1
        for var i=0; i<arrayCompleto.count; i++ {
            let userRepo = arrayCompleto[i]["user"] as! NSDictionary
            let login = userRepo["login"] as! String
            if login == user.username {
                number = arrayCompleto[i]["number"] as! Int
                break
            }
        }
        
        if number>0 {
            let urlPull = "https://api.github.com/repos/mackmobile/\(nomeRepo)/issues/\(number)"
            let userPull = conn.connectOne(user.username, password: user.password, urlBusca: urlPull)
            if let labels: AnyObject = userPull["labels"] as? NSArray {
                BadgeManager.sharedInstance.removeAll()
                for var i=0; i<labels.count; i++ {
                    var badge = BadgeManager.sharedInstance.newBadge()
                    badge.name = labels[i]["name"] as! String
                    badge.color = labels[i]["color"] as! String
                    badges.addObject(badge)
                    BadgeManager.sharedInstance.save()
                }
            }
        }
        return badges
    }
    
}