//
//  NoteDataProvider.swift
//  Notes
//
//  Created by Nikita Yakovlev on 11.04.2022.
//

import Foundation

class NoteArrayDataProvider {
    private let noteArrayKey = "notesArray"
    private static  let dateFormat = "dd-MM-yyyy"
    private let dateFormatter = DateFormatter()
    private init() { }

    static private var instance: NoteArrayDataProvider?

    static func getInstance() -> NoteArrayDataProvider {
        if let provider = instance {
            return provider
        }
        instance = NoteArrayDataProvider()
        instance?.dateFormatter.dateFormat = dateFormat
        return instance!
    }

    func getSavedNotes() -> [Note]? {
        let decoder = JSONDecoder()
        var arrayNotes = [Note]()

        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        guard let encodedArray = UserDefaults.standard.object(forKey: noteArrayKey) as? [Data] else {
            return nil
        }

        for item in encodedArray {
            if let note = try? decoder.decode(Note.self, from: item) {
                arrayNotes.append(note)
            }
        }
        return arrayNotes
    }

    func saveNotes(_ notes: [Note]) {
        let encoder = JSONEncoder()
        var encodedArray = [Data]()

        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        for item in notes {
            if let encodedNote = try? encoder.encode(item) {
                encodedArray.append(encodedNote)
            }
        }

        UserDefaults.standard.set(encodedArray, forKey: noteArrayKey)
    }
}
