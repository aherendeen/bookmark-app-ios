import CoreData

/// CoreData entity: Bookmark (id, title, url, desc, folder, dateCreated, dateModified).
/// The model is defined in code (see CoreDataHelper) so no .xcdatamodeld is needed.
/// `desc` is used because `description` clashes with NSObject.description.
@objc(Bookmark)
public class Bookmark: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var desc: String
    @NSManaged public var folder: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateModified: Date

    static let defaultFolder = "Unsorted"

    static func fetchRequest() -> NSFetchRequest<Bookmark> {
        NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }
}
