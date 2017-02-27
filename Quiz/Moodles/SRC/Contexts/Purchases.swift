//
//  MDPurchasesContext.swift
//  Moodles
//
//  Created by VladislavEmets on 12/13/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseDatabase
import FirebaseStorage


func getAllPurchases() -> Promise<[MDPurchase]> {
    return Promise.init(resolvers: {resolve, reject in
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child(MDFirebase.Database.purchases).observeSingleEvent(of: FIRDataEventType.value, with: { snapshot in
            var purchases: [MDPurchase] = []
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? FIRDataSnapshot {
                if let info = snap.value as? Dictionary<String, String> {
                    let purchase = MDPurchase(item: info[MDFirebase.Database.itemID] ?? "",
                                              title: info[MDFirebase.Database.title] ?? "",
                                              description: info[MDFirebase.Database.desciption] ?? "")
                    purchases.append(purchase)
                }
            }
            resolve(purchases)
        }, withCancel: { error in
            reject(error)
        })
    })
}
