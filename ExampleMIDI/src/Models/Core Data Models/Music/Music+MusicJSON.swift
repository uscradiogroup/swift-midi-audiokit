//
//  Music+MusicJSON.swift
//  ExampleMIDI
//
//  Created by Artem Chabannyi on 10/24/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import CoreData
import ReactiveCocoa
import MagicalRecord

extension Music {
    
    func toMusicJSON() -> SignalProducer<NSURL, NSError> {
        return SignalProducer{ (observer, compositeDisposable) in
            let context = NSManagedObjectContext.MR_context()
            context.performBlock{ [unowned context] in
                let music = self.MR_inContext(context)
                if let music = music, musicJson = musicToMusicJSONFile(music: music) {
                    observer.sendNext(musicJson)
                    observer.sendCompleted()
                } else {
                    observer.sendFailed(NSError(domain:"org.uscradiogroup", code: 0, userInfo: nil))
                }
            }
        }
    }
    
}
