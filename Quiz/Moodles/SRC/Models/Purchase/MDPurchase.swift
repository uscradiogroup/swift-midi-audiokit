//
//  MDPurchase.swift
//  Moodles
//
//  Created by VladislavEmets on 12/13/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import FirebaseStorage

class MDPurchase {
    var itemId: String
    var title: String
    var textDescription: String
    private var imageURLCached: URL?
    
    init(item: String, title: String, description: String) {
        self.itemId = item
        self.title = title
        self.textDescription = description
    }
    
    func getImageURL (complited: @escaping (URL?, Error?) -> Void) {
        if let url = imageURLCached {
            complited(url, nil)
        } else {
            let storageRef = FIRStorage.storage().reference()
            let path = MDFirebase.Storage.images /+ self.itemId + "." + MDFileSystem.Extension.png
            let imageRef: FIRStorageReference = storageRef.child(path)
            imageRef.downloadURL(completion: {[weak self](url, error) in
                if let result = url {
                    self?.imageURLCached = result
                }
                complited(url, error)
            })
        }
    }
    
}
