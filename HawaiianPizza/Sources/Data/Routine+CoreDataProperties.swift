//
//  Routine+CoreDataProperties.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/25/24.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var id: UUID
    @NSManaged public var routineTitle: String
    @NSManaged public var routineTime: Date
    @NSManaged public var totalSkipTime: Date?
    @NSManaged public var tasks: NSSet

}

// MARK: Generated accessors for tasks
extension Routine {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Routine : Identifiable {

}
