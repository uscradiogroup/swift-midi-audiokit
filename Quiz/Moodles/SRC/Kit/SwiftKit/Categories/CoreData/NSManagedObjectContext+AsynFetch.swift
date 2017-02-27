//
//  NSManagedObjectContext+AsynFetch.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObjectContext {
    
    public typealias PersistentStoreAsynchronousFetchMusicCompletionBlock = (NSAsynchronousFetchResult<Music>) -> Swift.Void
    
    func AC_fetchAsync(fetchRequest:NSFetchRequest<NSManagedObject>,
                                    completionBlock:PersistentStoreAsynchronousFetchMusicCompletionBlock?)
    {
        let fetchRequest = NSFetchRequest<Music>(entityName: "Music")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let asyncFetch = NSAsynchronousFetchRequest(fetchRequest: fetchRequest, completionBlock: completionBlock)
        
        self.perform { [weak self] in
            if let strongSelf = self {
                do {
                    try strongSelf.execute(asyncFetch)
                } catch {
                    
                }
            }
        }
    }
    
}
