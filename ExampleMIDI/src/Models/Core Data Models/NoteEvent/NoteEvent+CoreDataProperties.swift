//
//  NoteEvent+CoreDataProperties.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/15/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation
import CoreData


extension NoteEvent {
    @NSManaged public var number: Int16
    @NSManaged public var velocity: Int16
    @NSManaged public var duration: Double

}
