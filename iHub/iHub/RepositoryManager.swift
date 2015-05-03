//
//  RepositoryManager.swift
//  iHub
//
//  Created by Fernando Lucheti on 02/05/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class RepositoryManager {
    static let sharedInstance:RepositoryManager = RepositoryManager()
    static let entityName:String = "Repository"
    lazy var managedContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var c = appDelegate.managedObjectContext
        return c!
        }()
    
    private init(){}
    
    func newRepository()->Repository
    {
        return NSEntityDescription.insertNewObjectForEntityForName(RepositoryManager.entityName, inManagedObjectContext: managedContext) as! Repository
    }
    
    func save()
    {
        var error:NSError?
        managedContext.save(&error)
        
        if let e = error {
            println("Could not save. Error: \(error), \(error!.userInfo)")
        }
    }
    
    func findRepositories()->Array<Repository>
    {
        let fetchRequest = NSFetchRequest(entityName: RepositoryManager.entityName)
        var error:NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Repository] {
            return results
        } else {
            println("Could not fetch. Error: \(error), \(error!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        
        return Array<Repository>()
    }
    
    
    func removeAll()->Bool{
        
        var fetchRequest = NSFetchRequest(entityName: RepositoryManager.entityName)
        fetchRequest.returnsObjectsAsFaults = false
        var results: NSArray = managedContext.executeFetchRequest(fetchRequest, error: nil)!
        
        if(results.count>0){
            for var i = 0; i < results.count; ++i{
                var res = results[i] as! NSManagedObject
                managedContext.deleteObject(res)
                managedContext.save(nil)
            }
            return true
        }
        
        return false
    }
}