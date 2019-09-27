//
//  List+Convenience.swift
//  Week2Assessment
//
//  Created by Austin Goetz on 9/27/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import Foundation
import CoreData

extension List {
    
    convenience init(itemName: String, isComplete: Bool, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.itemName = itemName
        self.isComplete = isComplete
        self.completed = true
    }
}
