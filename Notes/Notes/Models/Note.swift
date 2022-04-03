//
//  Note.swift
//  Notes
//
//  Created by Nikita Yakovlev on 01.04.2022.
//

import Foundation

struct Note {
    var title: String
    var text: String
    var date: Date?
    var isEmpty: Bool {
        return title.isEmpty && text.isEmpty
    }

    private let defaults = UserDefaults.standard

    init () {
        title = defaults.value(forKey: "title") as? String ?? ""
        text = defaults.value(forKey: "note") as? String ?? ""
    }

    func save() {
        defaults.set(title, forKey: "title")
        defaults.set(text, forKey: "note")
    }
}
