//
//  Note.swift
//  Notes
//
//  Created by Nikita Yakovlev on 01.04.2022.
//

import Foundation

struct Note: Codable {
    var title: String
    var text: String
    var date: Date
    var isEmpty: Bool {
        return title.isEmpty && text.isEmpty
    }

    var id: String = UUID().uuidString
    var online: Bool = false
    var userShareIcon: URL?

    enum CodingKeys: String, CodingKey {
        case title = "header"
        case text
        case date
        case userShareIcon
    }

    init (title: String, text: String, date: Date, online: Bool = false, userShareIcon: URL? = nil) {
        self.title = title
        self.text = text
        self.date = date
        self.online = online
        self.userShareIcon = userShareIcon
    }

    func getOnlineNote() -> Note {
        return Note(
            title: self.title,
            text: self.text,
            date: self.date,
            online: true,
            userShareIcon: self.userShareIcon
        )
    }

    mutating func setId(_ id: String) {
        self.id = id
    }
}
