//
//  URL+Extensions.swift
//  Moodles
//
//  Created by VladislavEmets on 2/16/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

extension URL {
    
    func queryParameters() -> [String:String] {
        let components = self.query?.components(separatedBy: "&")
        var parameters: [String:String] = [:]
        components?.map({
            (str:String) -> (String, String)? in
            let pair = str.components(separatedBy: "=")
            if pair.count == 2 {
                return (pair[0], pair[1])
            }
            return nil
        })
            .flatMap { $0 }
            .map {
                pair -> Void in
                parameters[pair.0] = pair.1
        }
        return parameters
    }
    
}
