//
//  ListNotesVieControllerMock.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 19.06.2022.
//

import Foundation
@testable import Notes

final class ListNotesViewControllerMock: ListNotesDisplayLogic {
    private (set) var displayDataWasCalled = false
    private (set) var updateDataWasCalled = false
    private (set) var showAlertWasCalled = false

    func displayData(_ viewModel: ListNotes.FetchNotes.ViewModel) {
        displayDataWasCalled = true
    }

    func updateKeepData(_ viewModel: ListNotes.DeleteNotes.ViewModel) {
        updateDataWasCalled = true
    }

    func showAlert(_ viewModel: ListNotes.AlertErrors.ViewModel) {
        showAlertWasCalled = true
    }
}
