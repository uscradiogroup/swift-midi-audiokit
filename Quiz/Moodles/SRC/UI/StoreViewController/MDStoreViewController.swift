//
//  MDStoreViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 11/17/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStoreKit


class MDStoreViewController:
UIViewController,
ViewControllerRootView,
UITableViewDelegate,
UITableViewDataSource {

    typealias RootViewType = MDStoreView
    var purchases:[MDPurchase] = []
    
    // MARK: -  Class methods
    
    // MARK: -  Initializations
    
    // MARK: -  LifecicleViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = getAllPurchases().then(execute: { purchases -> Void in
            self.purchases = purchases
            self.rootView.tableView.reloadData()
        })
    }
    
    
    // MARK: -  IBActions
    
    @IBAction func onBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBackToRecord(_ sender: Any) {
        backToRecord()
    }
    
    
    @IBAction func onRestorePurchases(_ sender: Any) {
        
    }
    
    // MARK: -  Overriden methods
    
    // MARK: -  UITableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        purchase(item: purchases[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MDPurchaseCell.self),
                                                 for: indexPath) as! MDPurchaseCell
        let model = purchases[indexPath.row]
        cell.fillFrom(model: model)
        cell.imageViewSeparator.isHidden = (model === purchases.last!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    // MARK: -  Public methods
    
    // MARK: -  Private methods

    fileprivate func purchase(item: MDPurchase) {
        SwiftyStoreKit.purchaseProduct(item.itemId, atomically: true, completion: { result in
            switch result {
            case .success(let product):
                print("Purchase Success: \(product.productId)")
            case .error(let error):
                print("Purchase Failed: \(error)")
            }
        })
    }
    
}
