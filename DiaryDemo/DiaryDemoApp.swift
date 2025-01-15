//
//  DiaryDemoApp.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/13/25.
//

import AppIntents
import SwiftData
import SwiftUI

@main
struct DiaryDemoApp: App {
    let container: ModelContainer
    let dataManager: DataManager
    let navigationManager: NavigationManager

    init() {
        do {
            container = try ModelContainer(for: Entry.self)
        } catch {
            fatalError("Could not create a ModelContainer for Entry")
        }

        let dataManager = DataManager(modelContext: container.mainContext)
        let navigationManager = NavigationManager()

        guard let dataManager else {
            fatalError("Swift Data manager could not be initialised")
        }

        AppDependencyManager.shared.add(dependency: dataManager)
        AppDependencyManager.shared.add(dependency: navigationManager)

        self.dataManager = dataManager
        self.navigationManager = navigationManager
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
        .environment(dataManager)
        .environment(navigationManager)
    }
}

