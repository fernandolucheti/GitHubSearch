//
//  Commit.swift
//  
//
//  Created by Fernando Lucheti on 02/05/15.
//
//

import Foundation
import CoreData

@objc(Commit)
class Commit: NSManagedObject {

    @NSManaged var descriptionText: String
    @NSManaged var owner: String
    @NSManaged var repository: Repository

}
