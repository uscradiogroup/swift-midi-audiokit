//
//  UploadMidiToFirebase.swift
//  Moodles
//
//  Created by VladislavEmets on 1/11/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseStorage


func uploadToFirebaseMIDIOf(_ music: Music) -> Promise<(Music, String)> {
    return Promise(resolvers: {fullfill, reject in
        let (saved, path) = saveMusicToMidFile(music: music, usingName: music.shareId())
        if !saved {
            reject(NSError(described: "Failed to save midi file"))
            return
        }
        
        let localFile = URL(fileURLWithPath: path!)
        let storageRef = FIRStorage.storage().reference()
        let firPath = MDFirebase.Storage.share /+ music.shareId() /+ music.name! + "." + MDFileSystem.Extension.midi
        let riversRef = storageRef.child(firPath)
        
        guard let data = FileManager.default.contents(atPath: localFile.path) else {
            reject(NSError(described: "Failed to get data from local file"))
            return
        }
        
        riversRef.put(data, metadata: nil) { metadata, error in
            if let error = error {
                reject(error)
            } else {
                fullfill((music, firPath))
            }
        }
        
    })
}


func downloadFirebaseFile(atPath path:String) -> Promise<URL> {
    return Promise(resolvers: { (fullfill, reject) in
        let (folderExist, savePath) = localFolder(.midis)
        guard let folderPath = savePath, folderExist == true else {
            reject(NSError(described: "Can not download to local Midi folder"))
            return
        }
        guard let fileName = path.components(separatedBy: CharacterSet(charactersIn: "/")).last else {
            reject(NSError(described: "Bad file name"))
            return
        }
        let localPath = folderPath /+ fileName
        let islandRef = FIRStorage.storage().reference().child(path)
        _ = islandRef.data(withMaxSize: MDFirebase.Storage.maxFileSize) { (data, error) in
            if let error = error {
                reject(error)
            } else {
                let fileManager = FileManager.default
                let saved = fileManager.createFile(atPath: localPath, contents: data, attributes: nil)
                let savedPath = URL(fileURLWithPath:localPath)
                if saved {
                    fullfill(savedPath)
                } else {
                    reject(NSError(described: "Failed to save file in documents"))
                }
            }
        }
    })
}


func removeStorageFileAtPath(_ file: String) {
    let desertRef = FIRStorage.storage().reference().child(file)
    desertRef.delete { (error) in
        print(error ?? "no delete error ")
    }
}


