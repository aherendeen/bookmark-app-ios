import CoreData

/// Owns the CoreData stack. Local SQLite store only; to add cloud sync later,
/// swap NSPersistentContainer for NSPersistentCloudKitContainer here.
final class CoreDataHelper {
    static let shared = CoreDataHelper()
    /// In-memory store for previews/tests.
    static let preview = CoreDataHelper(inMemory: true)

    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext { container.viewContext }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Bookmarks", managedObjectModel: Self.makeModel())
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("CoreData failed to load: \(error)") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /// Builds the data model programmatically.
    private static func makeModel() -> NSManagedObjectModel {
        func attr(_ name: String, _ type: NSAttributeType, indexed: Bool = false) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = type
            a.isOptional = false
            switch type {
            case .stringAttributeType: a.defaultValue = ""
            case .dateAttributeType: a.defaultValue = Date()
            default: break
            }
            return a
        }
        let entity = NSEntityDescription()
        entity.name = "Bookmark"
        entity.managedObjectClassName = NSStringFromClass(Bookmark.self)
        entity.properties = [
            attr("id", .UUIDAttributeType),
            attr("title", .stringAttributeType),
            attr("url", .stringAttributeType),
            attr("desc", .stringAttributeType),
            attr("folder", .stringAttributeType),
            attr("dateCreated", .dateAttributeType),
            attr("dateModified", .dateAttributeType)
        ]
        let model = NSManagedObjectModel()
        model.entities = [entity]
        return model
    }

    func save(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do { try context.save() } catch { print("CoreData save error: \(error)") }
    }

    /// Deletes every bookmark.
    func deleteAll(in context: NSManagedObjectContext) {
        let request = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark"))
        request.resultType = .resultTypeObjectIDs
        if let result = try? context.execute(request) as? NSBatchDeleteResult,
           let ids = result.result as? [NSManagedObjectID] {
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: ids], into: [context])
        }
    }
}
