//
//  MDNavigationProtocol.swift
//  Moodles
//
//  Created by VladislavEmets on 11/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import UIKit


enum MDRootScreen: String {
    case None
    case Record
    case Recordings
    case More
    
    var rawValue: String {
        switch self {
        case .None: return ""
        case .Record: return String(describing: RecordViewController.self)
        case .Recordings: return String(describing: RecordsListController.self)
        case .More: return String(describing: AppinfoViewController.self)
        }
    } 
}


protocol MDNavigationProtocol: class {
    func handleCenterItemPressed () -> Bool
    func showMusicFromFIRShare(fromFolder folder: String, named firFileName: String)
}


extension MDNavigationProtocol {
    func handleCenterItemPressed () -> Bool {
        return false
    }
    func showMusicFromFIRShare(fromFolder folder: String, named firFileName: String) {
        
    }
}



