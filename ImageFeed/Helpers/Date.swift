//
//  Date.swift
//  ImageFeed
//
//  Created by Анастасия on 03.09.2023.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM yyyy"
    return formatter
}()

extension Date {
    var dateTimeString: String { dateFormatter.string(from: self) }
}
