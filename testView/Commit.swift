//
//  Commit.swift
//  testView
//
//  Created by Humberto  Julião on 02/05/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import Foundation
import CoreData

class Commit: NSManagedObject {

    @NSManaged var descricao: String
    @NSManaged var dono: String
    @NSManaged var eParteDe: NSManagedObject

}
