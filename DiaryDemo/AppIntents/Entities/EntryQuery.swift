//
//  EntryQuery.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/14/25.
//

import AppIntents

extension DiaryEntryEntity {
    struct DiaryEntryQuery: EntityStringQuery {

        @Dependency var dataManager: DataManager

        func entities(for identifiers: [DiaryEntryEntity.ID]) async throws -> [DiaryEntryEntity] {
            print("Querying for identifers: \(identifiers)")

            return dataManager.entries(for: identifiers).map {
                DiaryEntryEntity($0)
            }
        }

        func entities(matching string: String) async throws -> [DiaryEntryEntity] {
            print("Querying for string: \(string)")

            return dataManager.entries(matching: string).map {
                DiaryEntryEntity($0)
            }
        }
    }
}
