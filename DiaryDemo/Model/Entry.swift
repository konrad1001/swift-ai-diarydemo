//
//  Entry.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/13/25.
//

import SwiftData
import SwiftUI

@Model
class Entry {
    var id = UUID()

    var title: String
    var text: String
    var date: Date

    init(title: String, text: String, date: Date) {
        self.title = title
        self.text = text
        self.date = date
    }
}
