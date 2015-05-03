//
//  BadgeManager.swift
//  iHub
//
//  Created by Fernando Lucheti on 02/05/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import CoreData
import UIKit

public class BadgeManager {
    static let sharedInstance:BadgeManager = BadgeManager()
    static let entityName:String = "Badge"
    lazy var managedContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var c = appDelegate.managedObjectContext
        return c!
        }()
    
    private init(){}
    
    func newBadge()->Badge
    {
        return NSEntityDescription.insertNewObjectForEntityForName(BadgeManager.entityName, inManagedObjectContext: managedContext) as! Badge
    }
    
    func save()
    {
        var error:NSError?
        managedContext.save(&error)
        
        if let e = error {
            println("Could not save. Error: \(error), \(error!.userInfo)")
        }
    }
    
    func findBadges()->Array<Badge>
    {
        let fetchRequest = NSFetchRequest(entityName: BadgeManager.entityName)
        var error:NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Badge] {
            return results
        } else {
            println("Could not fetch. Error: \(error), \(error!.userInfo)")
        }
        return Array<Badge>()
    }
    
    
    func removeAll()->Bool{
        
        var fetchRequest = NSFetchRequest(entityName: BadgeManager.entityName)
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