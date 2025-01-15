//
//  Extensions.swift
//  DiaryDemo
//
//  Created by Konrad Painta on 1/13/25.
//

import SwiftUI

extension Date {
    func shortString() -> String {
        let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                return formatter
            }()

        return dateFormatter.string(from: self)
    }
}
