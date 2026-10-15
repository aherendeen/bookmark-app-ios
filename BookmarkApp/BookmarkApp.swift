import SwiftUI

/// App entry point. Creates the CoreData stack and the shared view model.
@main
struct BookmarkApp: App {
    private let persistence = CoreDataHelper.shared
    @StateObject private var viewModel = BookmarkViewModel(context: CoreDataHelper.shared.viewContext)

    var body: some Scene {
        WindowGroup {
            TabView {
                BookmarkListView()
                    .tabItem { Label("Bookmarks", systemImage: "bookmark") }
                AddBookmarkView()
                    .tabItem { Label("Add", systemImage: "plus.circle") }
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
            .environmentObject(viewModel)
            .environment(\.managedObjectContext, persistence.viewContext)
        }
    }
}
