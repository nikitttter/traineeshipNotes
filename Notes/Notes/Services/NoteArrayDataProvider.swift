//
//  NoteDataProvider.swift
//  Notes
//
//  Created by Nikita Yakovlev on 11.04.2022.
//

import Foundation

protocol NoteStorage {
    func getSavedNotes() -> [Note]?
    func saveNotes(_ notes: [Note])
}

class NoteArrayDataProvider {
    private let noteArrayKey = "notesArray"
    private static  let dateFormat = "dd.MM.yyyy EEEE HH:mm"
    private let dateFormatter = DateFormatter()
    private init() {
        print("class NoteArrayDataProvider has been initialized")
    }
    deinit {
        print("class NoteArrayDataProvider has been deallocated")
    }
    static private var instance: NoteArrayDataProvider?

    static func getInstance() -> NoteArrayDataProvider {
        if let provider = instance {
            return provider
        }
        instance = NoteArrayDataProvider()
        instance?.dateFormatter.dateFormat = dateFormat
        return instance!
    }
}

// MARK: NoteStorage protocol

extension NoteArrayDataProvider: NoteStorage {
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
