# Bookmark App (iOS)

A minimal, offline-first bookmark manager built with SwiftUI and CoreData. Targets iOS 16+.

## Features
- Save links with title, URL, optional description and folder
- Local persistent storage (CoreData, no account, no cloud)
- Folder organisation (bookmarks listed grouped by folder)
- Search across title, URL and description
- Dark mode and Dynamic Type via system styles
- Tabs: Bookmarks, Add, Settings (clear all data, about)

## Setup
1. In Xcode 15+: **File > New > Project > iOS > App** (Interface: SwiftUI, Language: Swift, Storage: None). Name it `BookmarkApp`, deployment target iOS 16.0.
2. Delete the generated `ContentView.swift`, app file and `Assets.xcassets`.
3. Drag the contents of the `BookmarkApp/` folder of this repo into the project (copy items, add to target).
4. Build and run (⌘R).

The CoreData model is defined in code (`Helpers/CoreDataHelper.swift`), so no `.xcdatamodeld` is required.
Add a 1024×1024 PNG to `Assets.xcassets/AppIcon.appiconset` for an app icon.

## Structure
```
BookmarkApp/
  BookmarkApp.swift          App entry, tab bar
  Models/Bookmark.swift      CoreData entity
  ViewModels/                BookmarkViewModel (all data access)
  Views/                     BookmarkListView, AddBookmarkView, SettingsView
  Helpers/                   CoreDataHelper (stack), SearchLogic (search/grouping/URL validation)
  Assets.xcassets/           Accent color, app icon slot
```

## Future work
Views only talk to `BookmarkViewModel`, and the store lives in `CoreDataHelper`, so cloud sync
(e.g. `NSPersistentCloudKitContainer`), a share extension, tags and export can be added without touching the UI.
