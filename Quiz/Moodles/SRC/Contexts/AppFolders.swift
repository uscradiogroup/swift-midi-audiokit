//
//  AppFolders.swift
//  Moodles
//
//  Created by VladislavEmets on 1/25/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

enum AppFolder{
    case midis
    case musicJSON
    
    func name() -> String {
        switch self {
        case .midis:
            return MDFileSystem.Folder.midis
        case .musicJSON:
            return MDFileSystem.Folder.musicJSON
        }
    }
}

func localFolder(_ folder: AppFolder) -> (folderExist: Bool, path: String?) {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let fileManager = FileManager.default
    let folderPath = documentsPath /+ folder.name()
    if fileManager.fileExists(atPath: folderPath) == false {
        do {
            try fileManager.createDirectory(atPath: folderPath,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch {
            return (folderExist: false, path: nil)
        }
    }
    return (folderExist: true, path: folderPath)
}
