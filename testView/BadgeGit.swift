//
//  BadgeGit.swift
//  testView
//
//  Created by Humberto  Julião on 02/05/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import Foundation
import CoreData

class BadgeGit: NSManagedObject {

    @NSManaged var color: String
    @NSManaged var name: String
    @NSManaged var pertence: NSManagedObject

}
