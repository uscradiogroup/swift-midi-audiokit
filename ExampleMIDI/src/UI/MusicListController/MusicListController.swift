//
//  RecordsListController.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/14/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import MagicalRecord

class MusicListController: UIViewController, ViewControllerRootView, UITableViewDataSource, UITableViewDelegate {

    typealias RootViewType = MusicListView
    
    var musicPlayer: MusicPlayer? = MusicPlayer()
    
    var tableViewFetchController: TableViewFetchController!
    
    lazy var fetchControllerAdapter: TableViewFetchController = {  [unowned self] in
        let tableViewFetchController = TableViewFetchController(tableView: self.rootView.tableView,
                                                                fetchedResultsController: self.getFetchResultController())
        return tableViewFetchController
    }()
    
    var fetchResultController: NSFetchedResultsController {
        return self.fetchControllerAdapter.fetchedResultsController
    }
    
    // MARK: - init and deinit methods
    
    deinit {
        self.musicPlayer?.stop()
    }
    
    // MARK: - view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performFetch()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.musicPlayer?.preparePlayer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.musicPlayer?.stop()
    }
    
    // MARK: - Public mathods
    
    func musicFor(sender sender:UIButton) -> Music? {
        let tableView = self.rootView.tableView
        let loc = tableView.convertPoint(CGPointMake(sender.frame.midX, sender.frame.midY),
                                         fromView: sender.superview)
        let indexPath: NSIndexPath? = tableView.indexPathForRowAtPoint(loc)
        let music = self.fetchResultController.objectAtIndexPath(indexPath!) as! Music
        return music
    }
    
    func play(music music: Music) {
        self.musicPlayer?.play(music: music)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchResultController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchResultController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MusicTableViewCell", forIndexPath: indexPath) as! MusicTableViewCell
        let model = self.fetchResultController.objectAtIndexPath(indexPath) as! Music
        cell.fillFrom(model: model)
        return cell
    }
    
    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let music = self.fetchResultController.objectAtIndexPath(indexPath) as! Music
        if self.musicPlayer?.isPlaying == true {
            self.musicPlayer?.stop()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            play(music:  music)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.musicPlayer?.stop()
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            self.deleteRowAt(indexPath: index, tableView: tableView)
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: - private
    
    private func deleteRowAt(indexPath indexPath: NSIndexPath, tableView: UITableView) {
        let music = self.fetchResultController.objectAtIndexPath(indexPath) as! Music
        if let playedMusic = self.musicPlayer?.music where playedMusic == music {
            self.musicPlayer?.stop()
        }
        MagicalRecord.saveWithBlock({ (context) in
            let lMusic = (music.MR_inContext(context))! as Music
            lMusic.MR_deleteEntityInContext(context)
        })
    }
    
    private func getFetchResultController() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(entityName: "Music")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: NSManagedObjectContext.MR_defaultContext(),
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        return fetchResultController
    }
    
    private func performFetch() {
        do {
            try self.fetchResultController.performFetch()
        } catch { }
    }
}
