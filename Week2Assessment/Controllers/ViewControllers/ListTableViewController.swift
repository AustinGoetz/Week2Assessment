//
//  ListTableViewController.swift
//  Week2Assessment
//
//  Created by Austin Goetz on 9/27/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, ListTableViewCellDelegate {
    
    func buttonTapped(_ sender: ListTableViewCell) {
        guard let index = tableView.indexPath(for: sender)  else { return }
        let list = ListController.sharedInstance.fetchedResultsController.object(at: index)
        ListController.sharedInstance.toggle(list: list)
        sender.updateViews(list: list)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionNumber = Int(ListController.sharedInstance.fetchedResultsController.sections?[section].name ?? "zero")
        
        if sectionNumber == 0 {
            return "Complete"
        } else {
            return "Incomplete"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ListController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        let list = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        cell.delegate = self
        cell.updateViews(list: list)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let list = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ListController.sharedInstance.delete(list: list)
        }    
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        
        let addButton = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let newListBody = alert.textFields?[0].text else { return }
            ListController.sharedInstance.createList(itemName: newListBody, isComplete: false)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (_) in
        }
        alert.addAction(addButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
}

extension ListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade
            )
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        default: return
        }
    }
}
