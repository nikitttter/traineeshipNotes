//
//  NoteArrayDataProviderMock.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 19.06.2022.
//

import Foundation
@testable import Notes

final class NoteArrayDataProviderMock: NoteStorage {
    private (set) var getSavedNotesWasCalled = false
    private (set) var saveNotesWasCalled = false
    let savedNotes = [Note(title: "testTitle", text: "testBody", date: .now)]

    func getSavedNotes() -> [Note]? {
        getSavedNotesWasCalled = true
        return savedNotes
    }

    func saveNotes(_ notes: [Note]) {
        saveNotesWasCalled = true
    }
}
