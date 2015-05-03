//
//  Repository.swift
//  
//
//  Created by Fernando Lucheti on 03/05/15.
//
//

import Foundation
import CoreData

@objc(Repository)
class Repository: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var forked: NSNumber
    @NSManaged var badges: NSSet
    @NSManaged var commits: NSSet
    
    func addBadge(badge: Badge) {
        var badges = self.mutableSetValueForKey("badges")
        badges.addObject(badge)
    }
    
    func addCommit(commit: Commit) {
        var commits = self.mutableSetValueForKey("commits")
        commits.addObject(commit)
    }

}
