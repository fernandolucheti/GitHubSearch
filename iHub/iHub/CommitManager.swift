//
//  CommitManager.swift
//  iHub
//
//  Created by Fernando Lucheti on 02/05/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import CoreData
import UIKit

public class CommitManager {
    static let sharedInstance:CommitManager = CommitManager()
    static let entityName:String = "Commit"
    lazy var managedContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var c = appDelegate.managedObjectContext
        return c!
        }()
    
    private init(){}
    
    func newCommit()->Commit
    {
        return NSEntityDescription.insertNewObjectForEntityForName(CommitManager.entityName, inManagedObjectContext: managedContext) as! Commit
    }
    
    func save()
    {
        var error:NSError?
        managedContext.save(&error)
        
        if let e = error {
            println("Could not save. Error: \(error), \(error!.userInfo)")
        }
    }
    
    func findCommits()->Array<Commit>
    {
        let fetchRequest = NSFetchRequest(entityName: CommitManager.entityName)
        var error:NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Commit] {
            return results
        } else {
            println("Could not fetch. Error: \(error), \(error!.userInfo)")
        }
        return Array<Commit>()
    }
    
    func removeCommitFrom(repoName: String){
        var fetchRequest = NSFetchRequest(entityName: CommitManager.entityName)
        fetchRequest.returnsObjectsAsFaults = false
        var results: NSArray = managedContext.executeFetchRequest(fetchRequest, error: nil)!
        
        if(results.count>0){
            for var i = 0; i < results.count; ++i{
                var commit = results.objectAtIndex(i) as! Commit
                if commit.repository.name == repoName{
                    var res = results[i] as! NSManagedObject
                    managedContext.deleteObject(res)
                    managedContext.save(nil)
                }
                
            }
            
        }
        
        
    }

    
    func removeAll()->Bool{
        
        var fetchRequest = NSFetchRequest(entityName: CommitManager.entityName)
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