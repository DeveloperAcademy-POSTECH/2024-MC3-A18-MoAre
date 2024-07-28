//
//  Task+CoreDataProperties.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID
    @NSManaged public var taskIcon: String
    @NSManaged public var taskTime: Date
    @NSManaged public var taskSkipTime: Date?
    @NSManaged public var taskName: String
    @NSManaged public var routine: Routine

}

extension Task : Identifiable {

}
