//
//  ListController.swift
//  Week2Assessment
//
//  Created by Austin Goetz on 9/27/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import Foundation
import CoreData

class ListController {
    
    
    static let sharedInstance = ListController()
    
    // Source of Truth
    var fetchedResultsController: NSFetchedResultsController<List>
    
    init() {
        let request: NSFetchRequest<List> = List.fetchRequest()
        let completedSort = NSSortDescriptor(key: "completed", ascending: false)
        
        request.sortDescriptors = [completedSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "completed", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error fetching from fetch Controller \(#function) :\(error) : \(error.localizedDescription)")
        }
    }
    
    // CRUD
    // Create
    func createList(itemName: String, isComplete: Bool) {
        let newList = List(itemName: itemName, isComplete: isComplete)
        newList.itemName = itemName
        saveToPersistentStore()
    }
    
    // Delete
    func delete(list: List) {
        if let moc = list.managedObjectContext {
            moc.delete(list)
            saveToPersistentStore()
        }
    }
    
    func toggle(list: List) {
        list.completed.toggle()
        saveToPersistentStore()
    }
    
    // Persistence
    func saveToPersistentStore() {
        if CoreDataStack.context.hasChanges {
            try? CoreDataStack.context.save()
        }
    }
}
