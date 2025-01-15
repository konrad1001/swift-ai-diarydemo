//
//  EntryEditorView.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/13/25.
//

import AppIntents
import SwiftData
import SwiftUI

struct EntryEditorView: View {
    @Bindable var entry: Entry

    var body: some View {
        VStack {
            HStack {
                TextField("", text: $entry.title)
                    .font(.system(size: 24, weight: .bold))

                Spacer()

                Text(entry.date.shortString())
            }

            TextEditor(text: $entry.text)
                .padding(.bottom, 16)
                .foregroundStyle(.gray)
                .padding(.bottom, 16)
                .userActivity("Viewing Entry",
                              element: DiaryEntryEntity(entry)) { asset, activity in
                    print("Broadcasting is viewing entry")
                    activity.title = "Viewing a Diary Entry"
                    activity.keywords = Set(["Diary", "Entry"])
                    activity.appEntityIdentifier = EntityIdentifier(for: asset)
                }
        }
        .padding()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Entry.self, configurations: config)

        let example = Entry(title: "Title", text: "text", date: Date())

        return EntryEditorView(entry: example)
            .modelContainer(container)

    } catch {
        fatalError("failed to create preview model")
    }
}
