//
//  CoreDataStack.swift
//  Week2Assessment
//
//  Created by Austin Goetz on 9/27/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Week2Assessment")
        // '_' IDGAFOS                                  ^ Rename to name of project file
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to Load Persistent Store \(error)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
