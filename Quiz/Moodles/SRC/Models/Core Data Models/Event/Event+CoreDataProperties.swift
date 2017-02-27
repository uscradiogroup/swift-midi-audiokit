//
//  Event+CoreDataProperties.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/15/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Event {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Event");
    }

    @NSManaged public var time: Double
    @NSManaged public var type: String?
    @NSManaged public var track: Track?

}
