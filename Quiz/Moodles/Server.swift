//
//  Server.swift
//  Moodles
//
//  Created by Tommy Trojan on 11/17/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import Firebase

class Server {
    
    static let sharedInstance = Server()
    
    let CALLBACK_NAME = "callbackFromServer"
    
    let notesInTrack = NSMutableSet()
    
    //Firebase
    let rootRef = FIRDatabase.database().reference()
    let ref = FIRDatabase.database().reference(withPath: "track-notes")
    var refHandle = FIRDatabaseHandle()
    
    private init(){
        listen()
    }
    
    //Listen whenever a child has been added
    func listen(){
        refHandle = ref.observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.CALLBACK_NAME), object: nil, userInfo: ["send": snapshot])
        })
    }
    
    func save(track:Track) -> String {
        //A. Get the Firebase Key
        let firebaseKey = ref.childByAutoId()
        //B. Convert the performance to JSON
        let json = track.serialize()
        //C. FIXME - I don't know what this does
        notesInTrack.add(firebaseKey)
        //D. Save to Firebase server
        firebaseKey.setValue(json) { (error, ref) in
            if let error = error {
                 print("Error saving to Firebase \(error.localizedDescription)")
            } else {
                self.notesInTrack.remove(firebaseKey)
            }
        }
        //E. 
        return firebaseKey.key
    }
    
}
