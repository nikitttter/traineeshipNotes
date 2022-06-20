//
//  ListNotesViewControllerTests.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 19.06.2022.
//

import XCTest
@testable import Notes

class ListNotesViewControllerTests: XCTestCase {
    var sut: ListNotesViewController!

    var interactor: ListNotesInteractorMock!
    var tableView: TableViewMock!

    override func setUp() {
        super.setUp()
        interactor = ListNotesInteractorMock()
        let viewController = ListNotesViewController(interactor: interactor, router: nil)
        tableView = TableViewMock()

        viewController.tableView = tableView
        viewController.tableView.dataSource = viewController
        sut = viewController
    }

    override func tearDown() {
        interactor = nil
        sut = nil
        tableView = nil

        super.tearDown()
    }

    func testsDisplayData() {
        let viewModel: ListNotes.FetchNotes.ViewModel = .init(displayedNotes: [
            ListNotes.PreviewNote(title: "testTitle", text: "testBody", date: "2022"),
            ListNotes.PreviewNote(title: "testTitle", text: "testBody", date: "2022")
        ])

        sut.displayData(viewModel)

        XCTAssertTrue(tableView.reloadDataWasCalled, "ViewController must call tableView's method reloadData")
        XCTAssertEqual(
            sut.tableView.numberOfRows(inSection: 0),
            viewModel.displayedNotes.count,
            "TableView's data sourse must be updated"
        )
    }

    func testsUpdateData() {
        let viewModel: ListNotes.DeleteNotes.ViewModel = .init(updatedNotes: [
            ListNotes.PreviewNote(title: "testTitle", text: "testBody", date: "2022"),
            ListNotes.PreviewNote(title: "testTitle", text: "testBody", date: "2022")
        ])

        sut.updateData(viewModel)

        XCTAssertFalse(tableView.reloadDataWasCalled, "ViewController must call tableView's method reloadData")
        XCTAssertEqual(
            sut.tableView.numberOfRows(inSection: 0),
            viewModel.updatedNotes.count,
            "TableView's data sourse must be updated"
        )
    }
}
