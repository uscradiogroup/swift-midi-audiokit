//
//  FetchControllerAdapter.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/19/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import CoreData
import ReactiveCocoa
import Result

typealias ItemChangeTuple = (indexPath: NSIndexPath?, type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?, anObject: AnyObject, controller: NSFetchedResultsController)
typealias SectionChangeTuple = (controller: NSFetchedResultsController, sectionInfo: NSFetchedResultsSectionInfo, sectionIndex: Int, type: NSFetchedResultsChangeType)

class FetchControllerAdapter: NSObject, NSFetchedResultsControllerDelegate {
    
    let willChangeContentSignal: Signal<NSFetchedResultsController, NoError>
    let itemChangeSignal: Signal <ItemChangeTuple, NoError>
    let sectionChangeSignal: Signal <SectionChangeTuple, NoError>
    let didChangeContentSignal: Signal<NSFetchedResultsController, NoError>
    
    private let willChangeObserver: Observer<NSFetchedResultsController, NoError>
    private let itemChangeObserver: Observer<ItemChangeTuple, NoError>
    private let sectionChangeObserver: Observer<SectionChangeTuple, NoError>
    private let didChangeContentObserver: Observer<NSFetchedResultsController, NoError>
    
    var numberOfSections: Int {
        return (self.fetchedResultsController.sections?.count)!
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        didSet {
            oldValue.delegate = nil
            fetchedResultsController.delegate = self
            do {
                try fetchedResultsController.performFetch()
            } catch {
                
            }

        }
    }
    
    deinit {
        self.fetchedResultsController.delegate = nil
    }
    
     init(fetchedResultsController: NSFetchedResultsController) {
        self.fetchedResultsController = fetchedResultsController
        let (willChangeContentSignal, willChangeObserver) = Signal<NSFetchedResultsController, NoError>.pipe()
        self.willChangeContentSignal = willChangeContentSignal
        self.willChangeObserver = willChangeObserver
        
        let (itemChangeSignal, itemChangeObserver) = Signal<ItemChangeTuple, NoError>.pipe()
        self.itemChangeSignal = itemChangeSignal
        self.itemChangeObserver = itemChangeObserver
        
        let (sectionChangeSignal, sectionChangeObserver) = Signal<SectionChangeTuple, NoError>.pipe()
        self.sectionChangeSignal = sectionChangeSignal
        self.sectionChangeObserver = sectionChangeObserver
        
        let (didChangeContentSignal, didChangeContentObserver) = Signal<NSFetchedResultsController, NoError>.pipe()
        self.didChangeContentSignal = didChangeContentSignal
        self.didChangeContentObserver = didChangeContentObserver
        
        super.init()
        
        fetchedResultsController.delegate = self
    }
    
    // MARK: public functions
    
    func numberOfItemsIn(section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.willChangeObserver.sendNext(controller)
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                                    atIndexPath indexPath: NSIndexPath?,
                                                forChangeType type: NSFetchedResultsChangeType,
                                                              newIndexPath: NSIndexPath?)
    {
        let value = ItemChangeTuple(indexPath: indexPath, type: type, newIndexPath: newIndexPath, anObject: anObject, controller:controller)
        self.itemChangeObserver.sendNext(value)
    }

    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                    atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
    {
        let value = SectionChangeTuple(controller: controller, sectionInfo: sectionInfo, sectionIndex: sectionIndex, type: type)
        self.sectionChangeObserver.sendNext(value)
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.didChangeContentObserver.sendNext(controller)
    }
}
