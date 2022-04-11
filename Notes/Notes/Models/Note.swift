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

    enum CodingKeys: CodingKey {
        case title, text, date
    }

    private let defaults = UserDefaults.standard
    static private let dateFormat = "dd-MM-yyyy"

    init (title: String, text: String, date: Date) {
        self.title = title
        self.text = text
        self.date = date
    }

    func getEncodedData() -> Data? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Note.dateFormat

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        do {
            return try encoder.encode(self)
        } catch let encodeError {
            print(encodeError)
            return nil
        }
    }

    static func getDecodedData(from item: Data) -> Note? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        do {
            return try decoder.decode(Note.self, from: item)
        } catch let decodedError {
            print(decodedError)
            return nil
        }
    }
}
