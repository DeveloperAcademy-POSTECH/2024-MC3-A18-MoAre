//
//  Tasks+CoreDataProperties.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 8/5/24.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var taskIcon: String?
    @NSManaged public var taskName: String?
    @NSManaged public var taskSkipTime: Int32
    @NSManaged public var taskTime: Int32
    @NSManaged public var taskTimestamp: Date?
    @NSManaged public var routine: Routine?

}

extension Tasks : Identifiable {

}
