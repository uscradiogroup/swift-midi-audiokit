//
//  Music+ToMidi.swift
//  ExampleMIDI
//
//  Created by Artem Chabannyi on 10/25/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import CoreData
import ReactiveCocoa
import MagicalRecord

extension Music {
    
    func toMidi() -> SignalProducer<String, NSError> {
        return SignalProducer{ (observer, compositeDisposable) in
            let context = NSManagedObjectContext.MR_context()
            context.performBlock{ [unowned context] in
                let music = self.MR_inContext(context)
                if let music = music {
                    let (saved, path) = saveMusicToMidFile(music: music)
                    if let path = path where true == saved {
                        observer.sendNext(path)
                        observer.sendCompleted()
                    } else {
                        observer.sendFailed(NSError(domain:"org.uscradiogroup", code: 0, userInfo: nil))
                    }
                } else {
                    observer.sendFailed(NSError(domain:"org.uscradiogroup", code: 0, userInfo: nil))
                }
            }
        }
    }
    
}
