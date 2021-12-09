import CoreData
import Foundation

final class DbUtil: NSObject {
    static let entityName = "Favorites"

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("error \(error!)")
            }
            container.viewContext.undoManager = nil
            container.viewContext.automaticallyMergesChangesFromParent = false
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container.shouldGroupAccessibilityChildren = true
        }
        return container
    }()

    static func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
}
