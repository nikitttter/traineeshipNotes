//
//  ListNotesPresenterTests.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 19.06.2022.
//

import XCTest
@testable import Notes

final class ListNotesPresenterTests: XCTestCase {
    var sut: ListNotesPresentationLogic!

    var viewController: ListNotesViewControllerMock!

    override func setUp() {
        super.setUp()

        let presenter = ListNotesPresenter()
        viewController = ListNotesViewControllerMock()
        presenter.viewController = viewController

        sut = presenter
    }

    override func tearDown() {
        sut = nil
        viewController = nil
        super.tearDown()
    }

    func testsPresentNotesWasCalled() {
        let response: ListNotes.FetchNotes.Response = .init(notes: [
            Note(title: "testTitle", text: "testBody", date: .now),
            Note(title: "testTitle", text: "testBody", date: .now)
        ])

        sut.presentNotes(response: response)
        XCTAssertTrue(
            viewController.displayDataWasCalled,
            "Presenter must call viewController's method displayData"
        )
    }

    func testsUpdateNotesWasCalled() {
        let response: ListNotes.DeleteNotes.Response = .init(notes: [
            Note(title: "testTitle", text: "testBody", date: .now),
            Note(title: "testTitle", text: "testBody", date: .now)
        ])

        sut.deleteNotes(response: response)
        XCTAssertTrue(
            viewController.updateDataWasCalled,
            "Presenter must call viewController's method updateData"
        )
    }

    func testsAlertNoSelectedNotesWasCalled() {
        sut.alertNoSelectedNote(response: .init(error: .notSelectedNotes))
        XCTAssertTrue(
            viewController.showAlertWasCalled,
            "Presenter must call viewController's method showAlert"
        )
    }
}
