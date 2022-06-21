//
//  NotePresenterTests.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 20.06.2022.
//

import XCTest
@testable import Notes

class NotePresenterTests: XCTestCase {
    var sut: NotePresentationLogic!

    var viewController: NoteDetailsViewControllerMock!

    override func setUp() {
        super.setUp()
        viewController = NoteDetailsViewControllerMock()
        let presenter = NotePresenter()
        presenter.viewController = viewController
        sut = presenter
    }

    override func tearDown() {
        viewController = nil
        sut = nil
        super.tearDown()
    }

    func testsPresentNoteDetails() {
        let response = NoteDetails.ShowNoteDetails.Response(
            noteHeader: "testHeader",
            noteText: "testText",
            noteDate: .now
        )

        sut.presentNoteDetails(response: response)

        XCTAssertTrue(
            viewController.displayNoteDetailsWasCalled,
            "Presenter must call viewController's method displayNoteDetails"
        )
        XCTAssertFalse(
            viewController.showAlertWasCalled,
            "Presenter mustn't call viewController's method showAlert"
        )
    }

    func testsPresentshowAlert() {
        let response = NoteDetails.UpdateNoteModel.Response(error: .emptyNote)

        sut.showAlert(response: response)

        XCTAssertTrue(viewController.showAlertWasCalled, "Presenter must call viewController's method showAlert")
    }
}
