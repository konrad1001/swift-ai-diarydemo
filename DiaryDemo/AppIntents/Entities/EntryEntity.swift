//
//  EntryEntity.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/14/25.
//

import AppIntents
import CoreLocation
import SwiftUI

@AssistantEntity(schema: .journal.entry)
struct DiaryEntryEntity: IndexedEntity {

    static let defaultQuery = DiaryEntryQuery()

    let id = UUID()

    var title: String?
    var message: AttributedString?
    var entryDate: Date?

    var mediaItems: [IntentFile]
    var location: CLPlacemark?

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: title.map { "\($0)" } ?? "Untitled",
            subtitle: "Entry"
        )
    }

    init(_ entry: Entry) {
        self.title = entry.title
        self.message = AttributedString(entry.text)
        self.entryDate = entry.date
    }
}

extension DiaryEntryEntity {
    private var textRepresentation: String {
        """
        \(title ?? "Empty Title")
        \(message ?? AttributedString("Empty text"))
        """
    }
}

extension DiaryEntryEntity: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .pdf) { entity in
            return try await entity.exported(as: .pdf)
        }
        ProxyRepresentation(exporting: \.textRepresentation)
    }
}
