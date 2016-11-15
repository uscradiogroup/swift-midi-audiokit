//
//  RecordsListController.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/14/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import MagicalRecord

class RecordsListController: MusicListController {

    typealias RootViewType = RecordsView
    
    private var docController: UIDocumentInteractionController?
    
    // MARK: - view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
    }
    
    // MARK - Interface actions
    
    @IBAction func onShare(_ sender: UIButton, event: UIEvent) {
        let music = musicFor(sender: sender)!
        self.shareMusic(music, sender: sender)
    }
    
    // MARK: - private
    
    private func setupNavBar() {
        let leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action:#selector(onBack))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.title = "Records List"
    }
    
    func onBack(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func shareMusic(music: Music, sender: UIButton) {
        // TODO: Temp solution. Find out better solution.
        let (_, path) = saveMusicToMidFile(music: music)
        let url = NSURL(fileURLWithPath: path!)
        self.docController = UIDocumentInteractionController(URL: url)
        docController?.UTI = "public.data"
        let view = self.view
        docController?.presentOptionsMenuFromRect(sender.superview!.convertRect(sender.frame, toView: view),
                                                       inView:view,
                                                       animated:true)
    }
}
