//
//  ExamplesViewController.swift
//  ExampleMIDI
//
//  Created by Artem Chabannyi on 10/24/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit

class ExamplesViewController: UIViewController, ViewControllerRootView, UITableViewDelegate, UITableViewDataSource {

    typealias RootViewType = ExamplesView
    
    var tableView: UITableView? {
        return self.rootView.tableView
    }
    
    private lazy var objects: [ExampleModel] = {
        let objects = [ExampleModel(title: "Record", withIdentifier: "PadViewController"),
                ExampleModel(title: "Load MIDI", withIdentifier: "LoadMidiViewController"),
                ExampleModel(title: "Export MIDI", withIdentifier: "ExportMidiViewController"),
                ExampleModel(title: "Export MusicJSON", withIdentifier: "ExportMusicJSONViewController")]
        return objects
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Examples"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExampleTableViewCell") as! ExampleTableViewCell
        let object = self.objects[indexPath.row]
        cell.fillFrom(model: object)
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = self.objects[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(object.withIdentifier)
        controller.title = object.title
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
