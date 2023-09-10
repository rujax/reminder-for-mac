//
//  Helper.swift
//  Reminder
//
//  Created by Rujax on 2023.
//

import Foundation

func currentTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"

    return formatter.string(from: Date())
}

func formatDate(_ date: Date = Date(), _ dateFormat: String = "yyyy-MM-dd' 'HH:mm:ss") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat

    return formatter.string(from: date)
}

func generateDate(_ dateString: String, _ dateFormat: String = "yyyy-MM-dd' 'HH:mm:ss") -> Date {
    if dateString == "" {
        return Date()
    }

    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat

    return formatter.date(from: dateString)!
}
