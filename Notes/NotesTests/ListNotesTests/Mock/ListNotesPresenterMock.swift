//
//  PresenterMock.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 17.06.2022.
//

import Foundation
@testable import Notes

final class ListNotesPresenterMock: ListNotesPresentationLogic {
    private (set) var presentNotesWasCalled = false
    private (set) var updateNotesWasCalled = false
    private (set) var  alertNoSelectedNoteWasCalled = false

    var responsePresent: ListNotes.FetchNotes.Response?
    var responseUpdate: ListNotes.DeleteNotes.Response?
    var responseAlert: ListNotes.AlertErrors.Response?

    func presentNotes(response: ListNotes.FetchNotes.Response) {
        presentNotesWasCalled = true
    }

    func deleteNotes(response: ListNotes.DeleteNotes.Response) {
        updateNotesWasCalled = true
    }

    func alertNoSelectedNote(response: ListNotes.AlertErrors.Response) {
        alertNoSelectedNoteWasCalled = true
    }
}
