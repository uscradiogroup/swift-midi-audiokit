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
    
    func AC_fetchAsync(fetchRequest fetchRequest:NSFetchRequest,
                                    completionBlock:NSPersistentStoreAsynchronousFetchResultCompletionBlock?)
    {
        let fetchRequest = NSFetchRequest(entityName: "Music")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let asyncFetch = NSAsynchronousFetchRequest(fetchRequest: fetchRequest, completionBlock: completionBlock)
        self.performBlock { [weak self] in
            if let strongSelf = self {
                do {
                    try strongSelf.executeRequest(asyncFetch)
                } catch {
                    
                }
            }
        }
    }
    
}
