//
//  Task+CoreDataProperties.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/31/24.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var taskIcon: String?
    @NSManaged public var taskName: String?
    @NSManaged public var taskSkipTime: Int32
    @NSManaged public var taskTime: Int32
    @NSManaged public var routine: Routine?

}

extension Task : Identifiable {

}
