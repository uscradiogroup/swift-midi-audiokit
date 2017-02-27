//
//  RecordsListController.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/14/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import MagicalRecord


class MusicListController:
UIViewController,
ViewControllerRootView,
UITableViewDataSource,
UITableViewDelegate {

    typealias RootViewType = MusicListView
    
    var musics: [Music] = []
    
    
    // MARK: - init and deinit methods
    
    // MARK: - view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performFetch()
    }

    
    // MARK: - Public mathods
    
    func musicFor(sender:UIButton) -> Music? {
        let tableView = self.rootView.tableView
        let loc = tableView?.convert(CGPoint(x: sender.frame.midX, y: sender.frame.midY),
                                         from: sender.superview)
        let indexPath: IndexPath? = tableView?.indexPathForRow(at: loc!)
        let music = musics[(indexPath?.row)!]
        return music
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
        let model = musics[indexPath.row]
        cell.fillFrom(model: model)
        cell.imageViewSeparator.isHidden = (model == musics.last!)
        return cell
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete", handler: { action, index in
            self.deleteRowAt(indexPath: index, tableView: tableView)
        })
        
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - private
    
    fileprivate func deleteRowAt(indexPath: IndexPath, tableView: UITableView) {
        let music = musics[indexPath.row]
        delete(music)
    }
    
    fileprivate func performFetch() {
        let fetched:[Music] = Music.mr_findAll() as! [Music]
        musics.append(contentsOf: fetched)
        rootView.tableView.reloadData()
    }

}
