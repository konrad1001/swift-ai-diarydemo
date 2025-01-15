//
//  DataManager.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/14/25.
//

import CoreSpotlight
import SwiftData
import SwiftUI

@Observable final class DataManager: @unchecked Sendable {

    var modelContext: ModelContext
    var entries = [Entry]()

    init?(modelContext: ModelContext, entries: [Entry] = [Entry]()) {
        self.modelContext = modelContext
        self.entries = entries

        try? fetchData()
    }

    private func fetchData() throws {
        let descriptor = FetchDescriptor<Entry>()
        entries = try modelContext.fetch(descriptor)

        let entities = entries.map { DiaryEntryEntity($0) }
        Task {
            try await CSSearchableIndex.default().indexAppEntities(entities)
        }
    }

    func createEntry(title: String? = nil, message: String? = nil, date: Date? = nil) throws -> Entry {
        let newEntry = Entry(
            title: title ?? "New Entry \(entries.count + 1)",
            text: message ?? "",
            date: date ?? Date())

        modelContext.insert(newEntry)

        try modelContext.save()

        entries.append(newEntry)

        Task {
            let entity = DiaryEntryEntity(newEntry)
            try await CSSearchableIndex.default().indexAppEntities([entity])
        }

        return newEntry
    }

    func deleteEntry(entry: Entry) throws {
        modelContext.delete(entry)

        try modelContext.save()

        entries.removeAll(where: {
            $0.id == entry.id
        })

        Task {
            let entity = DiaryEntryEntity(entry)
            try await CSSearchableIndex.default().deleteAppEntities(identifiedBy: [entity.id], ofType: DiaryEntryEntity.self)
        }
    }
}

/// Query functions
extension DataManager {
    func entries(for identifiers: [Entry.ID]) -> [Entry] {
        entries.compactMap { entry in
            return identifiers.contains(entry.id) ? entry : nil
        }
    }

    func entries(matching string: String) -> [Entry] {
        entries.filter { entry in
            return entry.title.localizedCaseInsensitiveContains(string)
        }
    }
}
