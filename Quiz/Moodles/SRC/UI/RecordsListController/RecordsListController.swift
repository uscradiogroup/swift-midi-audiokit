//
//  RecordsListController.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/14/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import MagicalRecord
import MessageUI
import Branch


class RecordsListController:
UIViewController,
MDNavigationProtocol,
ViewControllerRootView,
UITableViewDataSource,
UITableViewDelegate,
MFMailComposeViewControllerDelegate {
    
    typealias RootViewType = RecordsView
    
    private var musics: [Music] = []
    private let loadingView = ActivityView.activityView()
    private var docController: UIDocumentInteractionController?
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - view controller methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadTableContent()
        subscribeNotification()
    }

    
    // MARK - Interface actions
    
    @IBAction func onShare(_ sender: UIButton, event: UIEvent) {
        let music = musicFor(sender: sender)!
        showSongOptions(music: music, sender: sender)
    }
    
    
    // MARK - Public
    
    func onBack(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBackToRecord(_ sender: Any) {
        if let navigation = navigationController as? MDNavigationController {
            navigation.switchTo(screen: .Record)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MusicTableViewCell.self), for: indexPath) as! MusicTableViewCell
        let model = musics[indexPath.row]
        cell.fillFrom(model: model)
        cell.imageViewSeparator.isHidden = (model == musics.last!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushPlaybackControllerFor(music: musics[indexPath.row])
    }
    
    
    // MARK: - Public
    
    func showMusicFromFIRShare(fromFolder folder: String, named firFileName: String) {
        loadingView?.showActivityViewOn(view: rootView)
        let firPath = MDFirebase.Storage.share /+ folder /+ firFileName + "." + MDFileSystem.Extension.midi
        _ = downloadFirebaseFile(atPath: firPath).then(execute: { (url) in
            return parse(fileUrl: url)
        }).then(execute: { (music) -> Void in
            self.reloadTableContent()
            self.pushPlaybackControllerFor(music: music)
        }).catch(execute: { (error) in
            self.presentAlert(message: error.localizedDescription)
        }).always { [weak self] in
            self?.loadingView?.hideActivityView()
        }
    }
    
    
    // MARK: - Private
    
    @objc private func reloadTableContent() {
        musics.removeAll()
        let fetched:[Music] = Music.mr_findAll() as! [Music]
        musics.append(contentsOf: fetched)
        rootView.tableView.reloadData()
    }
    
    
    private func musicFor(sender:UIButton) -> Music? {
        guard let indexPath = self.rootView.tableView.indexPathForCellContains(view: sender) else {
            return nil
        }
        let music = musics[indexPath.row]
        return music
    }
    
    
    private func sendEmailWith(file path: String, filename name: String) {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        if let image = UIImage(named: "AppStore"),
            let data = UIImageJPEGRepresentation(image, CGFloat(1.0)) {
            mailController.addAttachmentData(data, mimeType: MDFileSystem.MimeType.imagejpeg,
                                             fileName:"test.jpeg")
        }
        mailController.setSubject("Check out my latest song")
        let body = (FIRAuth.auth()?.currentUser?.displayName ?? "Moodles user") +
        " wants you to listen to a song they created using Moodles."
        mailController.setMessageBody("<html><body><p>\(body)</p></body></html>", isHTML: true)
        let fileUrl = URL(fileURLWithPath: path)
        if let fileData = try? Data(contentsOf: fileUrl) {
            mailController.addAttachmentData(fileData,
                                             mimeType: MDFileSystem.MimeType.audiomidi,
                                             fileName: name)
            self.present(mailController, animated: true, completion: nil)
        }
    }
    
    private func generateDeeplinkStringFrom(music: Music, complited: @escaping (String?, Error?) -> Void) {
        let (deeplink, properties) = music.deeplink()
        uploadToFirebaseMIDIOf(music)
            .then { (music, firPath) -> Void in
                deeplink.getShortUrl(with: properties, andCallback: {
                    (string, error) in
                    complited(string, error)
                })
            }
            .catch(execute: { (error) in
                print(error.localizedDescription)
            })
    }
    
    private func subscribeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableContent),
                                               name: MDNotification.Name.openSharedMidiFile)
    }
    
    private func pushPlaybackControllerFor(music: Music) {
        guard let playbackController = storyboard?.instantiateViewController(describedByType: PlaybackViewController.self) else {
            return
        }
        playbackController.music = music
        navigationController?.pushViewController(playbackController, animated: true)
    }
    
    private func shareFileAt(url: URL) {
        self.docController = UIDocumentInteractionController(url: url)
        docController?.uti = "public.data"
        docController?.presentOptionsMenu(from: rootView.bounds,
                                          in:rootView,
                                          animated:true)
    }
    
    // MARK: - Music actions
    
    private func rename(music: Music, name: String?) {
        guard let text = name?.reducedTo(length: 100),
            text.isEmpty == false else {
                return
        }
        MagicalRecord.save({ (context) in
            let lMusic = (music.mr_(in: context))! as Music
            lMusic.name = text
        }, completion: { (saved, error) in
            self.rootView.tableView.reloadData()
        })
    }
    
    private func delete(music: Music) {
        MagicalRecord.save({ (context) in
            let lMusic = (music.mr_(in: context))! as Music
            lMusic.mr_deleteEntity(in: context)
        }, completion: {
            [weak self] (success, error) in
            if let index = self?.musics.index(of: music) {
                self?.musics.remove(at: index)
                self?.rootView.tableView.reloadData()
            }
        })
    }
    
    private func shareDeeplinkOf(music: Music) {
        let (deeplink, properties) = music.deeplink()
        uploadToFirebaseMIDIOf(music)
            .then { [weak self] (music, firPath) -> Void in
                deeplink.showShareSheet(with: properties,
                                        andShareText: "My performance",
                                        from: self,
                                        completion: { (activityType, completed) in
                                            if (!completed) {
                                                removeStorageFileAtPath(firPath)
                                            }
                })}
            .catch(execute: { (error) in
                print(error.localizedDescription)
            })
    }
    
    private func copyDeeplinkOf(music: Music) {
        loadingView?.showActivityViewOn(view: rootView)
        self.generateDeeplinkStringFrom(music: music, complited: { [weak self] (string, error) in
            self?.loadingView?.hideActivityView()
            string.map {
                UIPasteboard.general.string = $0
                self?.presentAlert(message: "Link was copied in to clipboard")
            }
            error.map {
                self?.presentAlert(message: $0.localizedDescription)
            }
        })
    }

    private func shareMIDIFileOf(_ music: Music) {
        if let path = saveMusicToMidFile(music: music).path {
            shareFileAt(url: URL(fileURLWithPath: path))
        }
    }
    
    private func shareMusicJSONFileOf(_ music: Music) {
        if let path = musicToMusicJSONFile(music: music)?.path {
            shareFileAt(url: URL(fileURLWithPath: path))
        }
    }
    
    
    // MARK: - Action Controllers
    
    fileprivate func showSongOptions (music: Music, sender: UIButton) {
        let options = UIAlertController(title: music.name, message: nil, preferredStyle: .alert)
        options.addAction(UIAlertAction.init(title: "Rename", style: .default, handler: {
            [weak self] action in
            self?.showEditNameDialog(music: music)
        }))
        options.addAction(UIAlertAction.init(title: "Delete", style: .default, handler: {
            [weak self] action in
            self?.showDeleteConfirmation(music: music)
        }))
        //This will send as Message, Facebook, or Twitter
        options.addAction(UIAlertAction.init(title: "Share", style: .default, handler: {
            [weak self] action in
            self?.shareDeeplinkOf(music: music)
        }))
        //This means copy Deeplink to clipboard
        options.addAction(UIAlertAction.init(title: "Copy Link", style: .default, handler: {
            [weak self] action in
            self?.copyDeeplinkOf(music: music)
        }))
        //This means export as MIDI file
        options.addAction(UIAlertAction.init(title: "Save as MIDI", style: .default, handler: {
            [weak self] action in
            self?.shareMIDIFileOf(music)
        }))
        //This means export as JSON file
        options.addAction(UIAlertAction.init(title: "Save as JSON", style: .default, handler: {
            [weak self] action in
            self?.shareMusicJSONFileOf(music)
        }))
        options.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: {
            action in
            options.dismiss(animated: true, completion: nil)
        }))
        
        self.present(options, animated: true, completion: nil)
    }
    
    
    fileprivate func showDeleteConfirmation(music: Music) {
        music.name.map {
            presentDeleteDialog(message: "",
                delete: "Delete",
                cancel: "Cancel",
                title: "Delete \"\($0)\"?",
                handler: {
                    [weak self] action in
                    self?.delete(music: music)
            })
        }
    }
    
    
    fileprivate func showEditNameDialog(music: Music) {
        presentAlertWithBlackKeyboard(title: "Name Your Moodle",
                                      message: nil,
                                      placeholder: "Record name",
                                      cancel: "Cancel",
                                      confirm: "Ok",
                                      onConfirm: {
                                        [weak self] string in
                                        self?.rename(music: music, name: string)
        })
    }
    
    
    // MARK: - MFMailComposeViewControllerDelegate

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension Music {
    fileprivate func deeplink() -> (BranchUniversalObject, BranchLinkProperties) {
        let branchlink = BranchUniversalObject(canonicalIdentifier: "music/" + self.shareId())
        branchlink.title = "Super amazing music I want to share!"
        branchlink.contentDescription = "My Content Description"
        branchlink.addMetadataKey(MDDeeplink.MetaKey.folder, value: self.shareId())
        branchlink.addMetadataKey(MDDeeplink.MetaKey.filename, value: self.name!)
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = MDDeeplink.feature
        linkProperties.channel = MDDeeplink.channel
        return (branchlink, linkProperties)
    }
}

