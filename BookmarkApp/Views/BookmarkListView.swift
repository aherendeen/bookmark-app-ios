import SwiftUI

/// Tab 1: searchable list of bookmarks grouped by folder.
struct BookmarkListView: View {
    @EnvironmentObject private var viewModel: BookmarkViewModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredGroups, id: \.folder) { group in
                    Section(group.folder) {
                        ForEach(group.items) { bookmark in
                            Button {
                                if let url = URL(string: bookmark.url) { openURL(url) }
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(bookmark.title).font(.headline).foregroundColor(.primary)
                                    Text(bookmark.url).font(.caption).foregroundColor(.accentColor).lineLimit(1)
                                    if !bookmark.desc.isEmpty {
                                        Text(bookmark.desc).font(.subheadline).foregroundColor(.secondary).lineLimit(2)
                                    }
                                }
                            }
                        }
                        .onDelete { offsets in
                            offsets.map { group.items[$0] }.forEach(viewModel.delete)
                        }
                    }
                }
            }
            .overlay {
                if viewModel.bookmarks.isEmpty {
                    Text("No bookmarks yet.\nTap Add to save your first link.")
                        .multilineTextAlignment(.center).foregroundColor(.secondary)
                } else if viewModel.filteredGroups.isEmpty {
                    Text("No results").foregroundColor(.secondary)
                }
            }
            .navigationTitle("Bookmarks")
            .searchable(text: $viewModel.searchText, prompt: "Search title, URL or description")
        }
    }
}
