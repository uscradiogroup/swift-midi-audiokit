//
//  Config.swift
//  CollectionView
//
//  Created by Tommy Trojan on 10/21/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit

class Config {
    
    let plist = (name: "Assets", type: "plist")
    
    func soundFontPath() -> String{
        guard let
            path = Bundle.main.path(forResource: plist.name, ofType: plist.type),
            let dict = NSDictionary(contentsOfFile: path)
        else { return "" }
        
        if let media = dict.object(forKey: "Media") {
            if let soundFont = (media as AnyObject).object(forKey: "SoundFont") {
                let path = (soundFont as AnyObject)[0] as! String
                return path
            }
        }
        return ""
    }
}
