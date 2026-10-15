import SwiftUI

/// Tab 3: clear data and about.
struct SettingsView: View {
    @EnvironmentObject private var viewModel: BookmarkViewModel
    @State private var confirmClear = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button("Clear All Data", role: .destructive) { confirmClear = true }
                }
                Section("About") {
                    LabeledContent("Version", value: "1.0 (MVP)")
                    Text("A minimal, offline-first bookmark manager. All data stays on this device.")
                        .font(.footnote).foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Delete all bookmarks? This cannot be undone.",
                                isPresented: $confirmClear, titleVisibility: .visible) {
                Button("Delete Everything", role: .destructive) { viewModel.deleteAll() }
            }
        }
    }
}
