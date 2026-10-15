import CoreData
import SwiftUI

/// Single source of truth for bookmarks. Views never touch CoreData directly,
/// so a sync layer can be added behind this class later.
final class BookmarkViewModel: ObservableObject {
    @Published private(set) var bookmarks: [Bookmark] = []
    @Published var searchText = ""

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        refresh()
    }

    var filteredGroups: [(folder: String, items: [Bookmark])] {
        SearchLogic.grouped(SearchLogic.filter(bookmarks, query: searchText))
    }

    var folders: [String] {
        Array(Set(bookmarks.map(\.folder) + [Bookmark.defaultFolder])).sorted()
    }

    func refresh() {
        let request = Bookmark.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        bookmarks = (try? context.fetch(request)) ?? []
    }

    /// Returns false if the URL is invalid or title empty.
    @discardableResult
    func add(title: String, url: String, desc: String, folder: String) -> Bool {
        guard let normalized = SearchLogic.normalizedURL(url) else { return false }
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanFolder = folder.trimmingCharacters(in: .whitespacesAndNewlines)
        let now = Date()
        let b = Bookmark(context: context)
        b.id = UUID()
        b.title = cleanTitle.isEmpty ? (normalized.host ?? normalized.absoluteString) : cleanTitle
        b.url = normalized.absoluteString
        b.desc = desc.trimmingCharacters(in: .whitespacesAndNewlines)
        b.folder = cleanFolder.isEmpty ? Bookmark.defaultFolder : cleanFolder
        b.dateCreated = now
        b.dateModified = now
        persist()
        return true
    }

    func delete(_ bookmark: Bookmark) {
        context.delete(bookmark)
        persist()
    }

    func deleteAll() {
        CoreDataHelper.shared.deleteAll(in: context)
        refresh()
    }

    private func persist() {
        CoreDataHelper.shared.save(context)
        refresh()
    }
}
