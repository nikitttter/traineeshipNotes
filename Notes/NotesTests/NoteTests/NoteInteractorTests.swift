//
//  NoteInteractorTests.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 20.06.2022.
//

import XCTest
@testable import Notes

class NoteInteractorTests: XCTestCase {
    var sut: NoteBusinesLogic!

    var presenter: NotePresenterMock!

    override func setUp() {
        super.setUp()
        presenter = NotePresenterMock()
        sut = NoteInteractor(presenter: presenter)
    }

    override func tearDown() {
        presenter = nil
        sut = nil
        super.tearDown()
    }

    func testsProvideNoteDetailNewNote() {
        sut.provideNoteDetail()

        XCTAssertFalse(presenter.showAlertWasCalled, "Interactor mustn't call presenter's method showAlert")
        XCTAssertTrue(presenter.presentNoteDetailsWasCalled, "Interactor must call presenter's method presentNote")
    }

    func testsUpdateNoteDetailWithNotEmptyNote() {
        let request = NoteDetails.UpdateNoteModel.Request(noteHeader: "testHeader", noteText: "testText")

        sut.updateNoteDetail(request: request)

        XCTAssertFalse(presenter.showAlertWasCalled, "Interactor mustn't call presenter's method showAlert")
        XCTAssertTrue(presenter.presentNoteDetailsWasCalled, "Interactor must call presenter's method presentNote")
    }

    func testsUpdateNoteDetailWithEmptyNote() {
        let request = NoteDetails.UpdateNoteModel.Request(noteHeader: "", noteText: "")

        sut.updateNoteDetail(request: request)

        XCTAssertTrue(presenter.showAlertWasCalled, "Interactor must call presenter's method showAlert")
        XCTAssertFalse(presenter.presentNoteDetailsWasCalled, "Interactor mustn't call presenter's method presentNote")
    }

    func testsSaveNotesWithNotEmptyNote() {
        let request = NoteDetails.SaveNoteModel.Request(noteHeader: "testHeader", noteText: "testText")
        sut.saveNote(request: request)

        XCTAssertFalse(presenter.showAlertWasCalled, "Interactor mustn't call presenter's method showAlert")
        XCTAssertFalse(presenter.presentNoteDetailsWasCalled, "Interactor mustn't call presenter's method presentNote")
    }

    func testsSaveNotesWithEmptyNote() {
        let request = NoteDetails.SaveNoteModel.Request(noteHeader: "", noteText: "")
        sut.saveNote(request: request)

        XCTAssertFalse(presenter.showAlertWasCalled, "Interactor mustn't call presenter's method showAlert")
        XCTAssertFalse(presenter.presentNoteDetailsWasCalled, "Interactor mustn't call presenter's method presentNote")
    }
}
