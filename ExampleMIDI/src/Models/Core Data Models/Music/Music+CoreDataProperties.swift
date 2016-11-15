//
//  Music+CoreDataProperties.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/15/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import CoreData


extension Music {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "Music");
    }

    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var tracks: NSSet?
    @NSManaged public var length: Double
    
}

// MARK: Generated accessors for tracks
extension Music {

    @objc(addTracksObject:)
    @NSManaged public func addToTracks(_ value: Track)

    @objc(removeTracksObject:)
    @NSManaged public func removeFromTracks(_ value: Track)

    @objc(addTracks:)
    @NSManaged public func addToTracks(_ values: NSSet)

    @objc(removeTracks:)
    @NSManaged public func removeFromTracks(_ values: NSSet)

}
