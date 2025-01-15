//
//  Intents.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/14/25.
//

import AppIntents
import CoreLocation

/// Create new diary entry
@AssistantIntent(schema: .journal.createEntry)
struct CreateDiaryEntryIntent {
    var title: String?
    var message: AttributedString
    var entryDate: Date?
    var location: CLPlacemark?

    @Parameter(default: [])
    var mediaItems: [IntentFile]

    @Dependency var dataManager: DataManager
    @Dependency var navigator: NavigationManager

    func perform() async throws -> some ReturnsValue<DiaryEntryEntity> {
        let text = String(message.characters)

        let entry = try dataManager.createEntry(title: title, message: text)

        navigator.open(entry)

        return .result(value: DiaryEntryEntity(entry))
    }
}

/// Search in system
@AssistantIntent(schema: .system.search)
struct SystemSearchIntent {
    static var searchScopes: [StringSearchScope] = [.general]

    var criteria: StringSearchCriteria

    @Dependency var navigator: NavigationManager

    func perform() async throws -> some IntentResult {
        navigator.openSearch(for: criteria.term)
        return .result()
    }
}
