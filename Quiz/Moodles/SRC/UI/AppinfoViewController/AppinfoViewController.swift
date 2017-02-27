//
//  AppinfoViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 11/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import FirebaseAuth


struct AppInfoItem {
    var title: String?
    var action: (()->Void)?
    var haveAccessory = true
    
    init (title: String, haveAccessory: Bool = true, action: @escaping ()->Void) {
        self.title = title
        self.action = action
        self.haveAccessory = haveAccessory
    }
    
    static func ==(lhs: AppInfoItem, rhs: AppInfoItem) -> Bool {
        return lhs.title == rhs.title
    }
}


class AppinfoViewController:
UIViewController,
MDNavigationProtocol,
ViewControllerRootView,
UITableViewDelegate,
UITableViewDataSource,
MFMailComposeViewControllerDelegate {
    
    typealias RootViewType = AppinfoView
    
    fileprivate var menu: [AppInfoItem] = []
    
    // MARK: -  Class methods
    
    // MARK: -  Initializations and Deallocations
    
    // MARK: -  LifecicleViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.withSlider()?.enableShortcut(true)
        setupTable()
    }
    
    // MARK: -  Accessors
    
    // MARK: -  IBActions

    @IBAction func onBackToRecord(_ sender: Any) {
        backToRecord()
    }
    
    // MARK: -  Public methods
    
    // MARK: -  Overriden methods
    
    // MARK: -  TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AppinfoCell.self),
                                                 for: indexPath) as! AppinfoCell
        let model = menu[indexPath.row]
        cell.fillFrom(model: model)
        cell.imageViewSepatator.isHidden = (model == menu.last!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: AppInfoItem = menu[indexPath.row]
        item.action?()
    }

    
    // MARK: -  Private methods
    
    fileprivate func setupTable () {
        menu.removeAll()
        menu.append(AppInfoItem(title: "Settings",
                                action:{ [weak self] in
                                    self?.presentDetails(controllerId: String(describing: MDMetronomeViewController.self), fromStoryboardNamed:MDStoryboards.main)
        }))
        menu.append(AppInfoItem(title: "Pop quiz",
                                action:{ [weak self] in
                                    self?.presentDetails(controllerId: String(describing: MDPregameViewController.self), fromStoryboardNamed:MDStoryboards.main)
        }))
        
        rootView.tableView.reloadData()
    }
    
    
    fileprivate func feedbackWithEmail() {
        if MFMailComposeViewController.canSendMail() == false {return}
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setSubject(MDVendorInfo.applicationName)
        mailController.setMessageBody("Feedback text", isHTML: false)
        mailController.setToRecipients([MDVendorInfo.supportMail])
        self.present(mailController, animated: true, completion: nil)
    }
    
    fileprivate func presentDetails(controllerId: String, fromStoryboardNamed name: String) {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: controllerId)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
        
    
}

