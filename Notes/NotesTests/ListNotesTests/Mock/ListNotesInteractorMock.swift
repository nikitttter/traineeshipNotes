//
//  ListNotesInteractorMock.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 19.06.2022.
//

import Foundation
@testable import Notes

final class ListNotesInteractorMock: ListNotesBusinesLogic {
    private (set) var fetchNotesWasCalled = false
    private (set) var fetchOnlineNotesWasCalled = false
    private (set) var deleteNotesWasCalled = false
    private (set) var saveNotesWasCalled = false

    func fetchNotes(_ update: ListNotes.FetchNotes.Request) {
        fetchNotesWasCalled = true
    }

    func fetchOnlineNotes() {
        fetchOnlineNotesWasCalled = true
    }

    func deleteNotes(by index: ListNotes.DeleteNotes.Request?) {
        deleteNotesWasCalled = true
    }

    func saveNotes() {
        saveNotesWasCalled = true
    }
}
