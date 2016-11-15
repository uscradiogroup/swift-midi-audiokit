//
//  ExportMusicJSONViewController.swift
//  ExampleMIDI
//
//  Created by Artem Chabannyi on 10/24/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ExportMusicJSONViewController: MusicListController {

    private var docController: UIDocumentInteractionController?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Interface Handling
    
    @IBAction func onExport(_ sender: UIButton) {
        if let music = musicFor(sender: sender) {
            self.shareMusic(music, sender: sender)
        }
    }
    
    // MARK: - Private mathods
    
    private func shareMusic(music: Music, sender: UIButton) {
        let activity = ActivityView.showOn(view: self.view)
        music.toMusicJSON()
            .observeOn(UIScheduler())
            .startWithResult { [weak self] result in
                activity.hideActivityView()
                switch result {
                case .Success(let url):
                    if let strongSelf = self {
                        let docController = UIDocumentInteractionController(URL: url)
                        strongSelf.docController = docController
                        docController.UTI = "public.text"
                        let view = strongSelf.view
                        docController.presentOptionsMenuFromRect(sender.superview!.convertRect(sender.frame, toView: view),
                            inView:view,
                            animated:true)
                    }
                case .Failure(_): break
                }
        }
    }

}
