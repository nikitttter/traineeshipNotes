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

    let id: String = UUID().uuidString
    var online: Bool = false

    enum CodingKeys: String, CodingKey {
        case title = "header"
        case text
        case date
    }

    init (title: String, text: String, date: Date, online: Bool = false) {
        self.title = title
        self.text = text
        self.date = date
        self.online = online
    }

    func getOnlineNote() -> Note {
        return Note(title: self.title, text: self.text, date: self.date, online: true)
    }
}
