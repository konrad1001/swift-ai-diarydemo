//
//  ShortcutsProvider.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/14/25.
//

import AppIntents

struct DiaryDemoShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CreateDiaryEntryIntent(),
            phrases: ["Create \(.applicationName) Entry"],
            shortTitle: "Create Entry",
            systemImageName: "pencil.and.outline"
        )
        AppShortcut(intent: SystemSearchIntent(),
                    phrases: ["Search \(.applicationName)"],
                    shortTitle: "Search Entry",
                    systemImageName: "magnifyingglass")
    }

    static let shortcutTileColor: ShortcutTileColor = .orange
}
