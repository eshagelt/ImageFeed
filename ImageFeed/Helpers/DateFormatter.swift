//
//  DateFormatter.swift
//  ImageFeed
//
//  Created by Анастасия on 23.01.2024.
//

import Foundation

final class CustomDateFormatters {
    static let shared = CustomDateFormatters()
    
    let iso8601DateFormatter: ISO8601DateFormatter
    let dateFormatter: DateFormatter
    private init() {
        iso8601DateFormatter = ISO8601DateFormatter()
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
    }
}
