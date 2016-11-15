//
//  TableViewFetchController.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/19/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TableViewFetchController: FetchControllerAdapter {
    
    private(set) var tableView: UITableView!
    var isBarchUpdate: Bool = true
    
    private var insertRowsAtIndexPaths: [NSIndexPath] = []
    private var deleteRowsAtIndexPaths: [NSIndexPath] = []
    private var updatedRowsAtIndexPaths: [NSIndexPath] = []
    private var insertSectionsIndexSet: NSMutableIndexSet = NSMutableIndexSet()
    private var deleteSectionsIndexSet: NSMutableIndexSet = NSMutableIndexSet()
    
    convenience init(tableView: UITableView, fetchedResultsController: NSFetchedResultsController) {
        self.init(fetchedResultsController: fetchedResultsController)
        self.tableView = tableView
        self.setupTableViewSignals()
    }
    
    // MARK: - private functions
    
    private func setupTableViewSignals() {
        self.willChangeContentSignal.observeNext { [unowned self] fetchedResultsController in
            if false == self.isBarchUpdate {
                self.tableView.beginUpdates()
            }
        }
        
        
        self.itemChangeSignal.observeNext { [unowned self] (indexPath, type, newIndexPath, anObject, controller) in
            var actionType = type
            
            if let indexPath = indexPath, newIndexPath = newIndexPath where  type == .Move && indexPath.isEqual(newIndexPath) {
                actionType = .Update
            }
            
            switch actionType {
            case .Insert:
                if self.isBarchUpdate {
                    self.insertRowsAtIndexPaths.append(newIndexPath!)
                } else {
                    self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
                }
            case .Delete:
                if self.isBarchUpdate {
                    self.deleteRowsAtIndexPaths.append(indexPath!)
                } else {
                    self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
                }
            case .Update:
                if self.isBarchUpdate {
                    self.updatedRowsAtIndexPaths.append(newIndexPath!)
                } else {
                    self.tableView.reloadRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
                }
            case .Move:
                if self.isBarchUpdate {
                    self.deleteRowsAtIndexPaths.append(indexPath!)
                    self.insertRowsAtIndexPaths.append(newIndexPath!)
                } else {
                    self.tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                }
            }
        }
        
        self.sectionChangeSignal.observeNext { [unowned self](controller, sectionInfo, sectionIndex, type) in
            switch type {
            case .Insert:
                if self.isBarchUpdate {
                    self.insertSectionsIndexSet.addIndex(sectionIndex)
                } else {
                    self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
                }
            case .Delete:
                if self.isBarchUpdate {
                    self.deleteSectionsIndexSet.addIndex(sectionIndex)
                } else {
                    self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
                }
            default:
                break
            }
        }
        
        self.didChangeContentSignal.observeNext { [unowned self] fetchedResultsController in
            if self.isBarchUpdate {
                let tableView = self.tableView
                let duration = 0.5
                let deleteRowAnimation: UITableViewRowAnimation = .Automatic
                let rowAnimation: UITableViewRowAnimation = .Automatic
                
                UIView.animateWithDuration(duration, animations: { 
                    tableView.beginUpdates()
                    
                    
                    tableView.deleteSections(self.deleteSectionsIndexSet, withRowAnimation: deleteRowAnimation)
                    tableView.insertSections(self.insertSectionsIndexSet, withRowAnimation: rowAnimation)
                    
                    tableView.deleteRowsAtIndexPaths(self.deleteRowsAtIndexPaths, withRowAnimation: deleteRowAnimation)
                    tableView.insertRowsAtIndexPaths(self.insertRowsAtIndexPaths, withRowAnimation: rowAnimation)
                    tableView.reloadRowsAtIndexPaths(self.updatedRowsAtIndexPaths, withRowAnimation: rowAnimation)
                    
                    tableView.endUpdates()
                    }, completion: nil)
                
            } else {
                self.tableView.endUpdates()
            }
            self.clearChanges()
        }
    }
    
    private func clearChanges() {
        self.insertSectionsIndexSet.removeAllIndexes()
        self.deleteSectionsIndexSet.removeAllIndexes()
        self.insertRowsAtIndexPaths.removeAll(keepCapacity: false)
        self.deleteRowsAtIndexPaths.removeAll(keepCapacity: false)
        self.updatedRowsAtIndexPaths.removeAll(keepCapacity: false)
    }
}
