//
//  ContentView.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/13/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @Environment(NavigationManager.self) private var navigator
    @Environment(DataManager.self) private var dataManager

    private var filteredEntries: [Entry] {
        let searchText = navigator.searchText

        guard !searchText.isEmpty else {
            return dataManager.entries
        }

        return dataManager.entries.filter {
            $0.title.lowercased()
                .contains(searchText.lowercased())
        }
    }

    var body: some View {
        @Bindable var navigator = navigator

        NavigationStack(path: $navigator.path) {
            VStack {
                List(filteredEntries) { entry in
                    NavigationLink(value: entry) {
                        HStack {
                            Text(entry.title)
                            Spacer()
                            Text(entry.date.shortString())
                                .foregroundStyle(.gray)
                        }

                    }
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            deleteEntry(entry: entry)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Diary")

                HStack {
                    Spacer()

                    Button(action: makeNewEntry, label: {
                        Image(systemName: "pencil")
                    })
                    .padding(.top, 16)
                }
            }
            .navigationDestination(for: Entry.self) { entry in
                EntryEditorView(entry: entry)
            }
            .padding()
        }
        .searchable(text: $navigator.searchText)
    }
}

// MARK: - View functions
extension ContentView {
    private func makeNewEntry() {
        do {
            let entry = try dataManager.createEntry()

            navigator.open(entry)
        } catch {
            print("Error saving entry")
        }
    }

    private func deleteEntry(entry: Entry) {
        do {
            try dataManager.deleteEntry(entry: entry)
        } catch {
            print("Error deleting entry")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Entry.self, configurations: config)

        return ContentView()
            .modelContainer(container)
            .environment(NavigationManager())

    } catch {
        fatalError("failed to create preview model")
    }
}
