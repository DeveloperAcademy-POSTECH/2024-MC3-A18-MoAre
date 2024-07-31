//
//  Routine+CoreDataProperties.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/31/24.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var routineTime: Int32
    @NSManaged public var routineTitle: String?
    @NSManaged public var totalSkipTime: Int32
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Routine {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Tasks)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Tasks)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Routine : Identifiable {

}
