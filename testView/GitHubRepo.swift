//
//  GitHubRepo.swift
//  testView
//
//  Created by Humberto  Julião on 02/05/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import Foundation
import CoreData

class GitHubRepo: NSManagedObject {

    @NSManaged var nomeRepo: String
    @NSManaged var possui: NSSet
    @NSManaged var tem: NSSet

}
