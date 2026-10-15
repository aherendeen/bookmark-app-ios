import SwiftUI

/// Tab 2: form for saving a bookmark.
struct AddBookmarkView: View {
    @EnvironmentObject private var viewModel: BookmarkViewModel
    @State private var title = ""
    @State private var url = ""
    @State private var desc = ""
    @State private var folder = Bookmark.defaultFolder
    @State private var showError = false
    @State private var showSaved = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("URL", text: $url)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Description (optional)", text: $desc, axis: .vertical)
                        .lineLimit(1...4)
                }
                Section("Folder") {
                    Picker("Folder", selection: $folder) {
                        ForEach(viewModel.folders, id: \.self) { Text($0).tag($0) }
                    }
                    TextField("Or create new folder", text: $folder)
                }
                Section {
                    Button("Save") { save() }
                        .disabled(url.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Add Bookmark")
            .alert("Invalid URL", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: { Text("Please enter a valid web address.") }
            .alert("Saved", isPresented: $showSaved) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    private func save() {
        if viewModel.add(title: title, url: url, desc: desc, folder: folder) {
            title = ""; url = ""; desc = ""
            showSaved = true
        } else {
            showError = true
        }
    }
}
