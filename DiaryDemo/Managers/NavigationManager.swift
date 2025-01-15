//
//  NavigationManager.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/14/25.
//

import Foundation
import SwiftUI

@Observable final class NavigationManager: @unchecked Sendable {
    var path = NavigationPath()

    var searchText = ""

    var searchIsFocused = false

    func open(_ entry: Entry) {
        path = NavigationPath()
        path.append(entry)
    }

    func openSearch(for text: String) {
        path = NavigationPath()

        searchText = text
        searchIsFocused = true
    }
}
