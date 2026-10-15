import Foundation

/// Pure search/grouping logic, independent of CoreData storage.
enum SearchLogic {
    /// Case/diacritic-insensitive match across title, URL and description.
    /// Every whitespace-separated term must match somewhere.
    static func matches(title: String, url: String, desc: String, query: String) -> Bool {
        let terms = query.split(whereSeparator: \.isWhitespace).map(String.init)
        guard !terms.isEmpty else { return true }
        let haystacks = [title, url, desc]
        return terms.allSatisfy { term in
            haystacks.contains { $0.range(of: term, options: [.caseInsensitive, .diacriticInsensitive]) != nil }
        }
    }

    static func filter(_ bookmarks: [Bookmark], query: String) -> [Bookmark] {
        bookmarks.filter { matches(title: $0.title, url: $0.url, desc: $0.desc, query: query) }
    }

    /// Groups by folder, folders sorted alphabetically, bookmarks by title.
    static func grouped(_ bookmarks: [Bookmark]) -> [(folder: String, items: [Bookmark])] {
        Dictionary(grouping: bookmarks, by: \.folder)
            .map { (folder: $0.key, items: $0.value.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }) }
            .sorted { $0.folder.localizedCaseInsensitiveCompare($1.folder) == .orderedAscending }
    }

    /// Adds a scheme when missing and verifies it is a usable http(s) URL.
    static func normalizedURL(_ raw: String) -> URL? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let withScheme = trimmed.contains("://") ? trimmed : "https://" + trimmed
        guard let url = URL(string: withScheme),
              let scheme = url.scheme?.lowercased(), ["http", "https"].contains(scheme),
              let host = url.host, !host.isEmpty else { return nil }
        return url
    }
}
