//
//  NoteViewController.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 20.06.2022.
//

import Foundation
@testable import Notes

final class NoteDetailsViewControllerMock: NoteDisplayLogic {
    private(set) var displayNoteDetailsWasCalled = false
    private(set) var showAlertWasCalled = false

    func displayNoteDetails(viewModel: NoteDetails.ShowNoteDetails.ViewModel) {
        displayNoteDetailsWasCalled = true
    }

    func showAlert(viewModel: NoteDetails.UpdateNoteModel.ViewModel) {
        showAlertWasCalled = true
    }
}
