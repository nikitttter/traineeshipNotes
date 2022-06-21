//
//  NotePresenterMock.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 20.06.2022.
//

import Foundation
@testable import Notes

final class NotePresenterMock: NotePresentationLogic {
    private(set) var presentNoteDetailsWasCalled = false
    private(set) var showAlertWasCalled = false

    func presentNoteDetails(response: NoteDetails.ShowNoteDetails.Response) {
        presentNoteDetailsWasCalled = true
    }

    func showAlert(response: NoteDetails.UpdateNoteModel.Response) {
        showAlertWasCalled = true
    }
}
