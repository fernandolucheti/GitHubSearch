//
//  Badge.swift
//  
//
//  Created by Fernando Lucheti on 02/05/15.
//
//

import Foundation
import CoreData

@objc(Badge)
class Badge: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var color: String
    @NSManaged var repository: Repository

}
