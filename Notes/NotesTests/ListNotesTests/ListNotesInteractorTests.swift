//
//  ListNotesInteractorTests.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 17.06.2022.
//

import XCTest
@testable import Notes

final class ListNotesInteractorTests: XCTestCase {
    var sut: (ListNotesBusinesLogic & ListNotesDataStore)!

    var presenterMock: ListNotesPresenterMock!
    var workerMock: WorkerMock!
    var dataProvider: NoteArrayDataProviderMock!

    override func setUp() {
        super.setUp()
        presenterMock = ListNotesPresenterMock()
        workerMock = WorkerMock()
        dataProvider = NoteArrayDataProviderMock()

        sut = ListNotesInteractor(
            presenter: presenterMock,
            worker: workerMock,
            dataProvider: dataProvider
        )
    }

    override func tearDown() {
        sut = nil
        presenterMock = nil
        workerMock = nil
        super.tearDown()
    }

    func testsfetchOnlineNotes() {
        sut.fetchOnlineNotes()

        XCTAssertTrue(workerMock.fetchDataWasCalled, "Interactor must call Worker's method fetchData")
        XCTAssert(
            sut.notes.first!.title == workerMock.notes.first!.title,
            "Object from worker must be equal interactor's data storage"
        )
        XCTAssert(presenterMock.presentNotesWasCalled, "Interactor must call Presenter's method presentNotes")
    }

    func testsfetchNotesfromStorage() {
        sut.fetchNotes(.init(getFromStorage: true))

        XCTAssert(dataProvider.getSavedNotesWasCalled, "Interactor must call DataProvider's method getSavedNotes")
        XCTAssert(
            sut.notes.first!.id == dataProvider.savedNotes.first!.id,
            "Object from dataProvider must be equal interactor's data storage"
        )
        XCTAssert(presenterMock.presentNotesWasCalled, "Interactor must call Presenter's method presentNotes")
    }

    func testsUpdateDataStore() {
        sut.fetchNotes(.init(getFromStorage: false))
        XCTAssert(
            dataProvider.getSavedNotesWasCalled == false,
            "Interactor mustn't call DataProvider's method getSavedNotes"
        )
        XCTAssert(presenterMock.presentNotesWasCalled, "Interactor must call Presenter's method presentNotes")
    }

    func testsDeleteNotesWithCorrectNoteId() {
        sut.notes.append(Note(title: "testTitle", text: "TestBody", date: .now))
        sut.deleteNotes(by: .init(id: 0))

        XCTAssertTrue(sut.notes.isEmpty, "Interactors's data store must be empty")
        XCTAssert(presenterMock.updateNotesWasCalled, "Interactor must call Presenter's method updateNotes")
        XCTAssertFalse(
            presenterMock.alertNoSelectedNoteWasCalled,
            "Interactor mustn't call Presenter's method alertNoSelectedNote"
        )
    }

    func testsDeleteNotesWithNilArgument() {
        sut.notes.append(Note(title: "testTitle", text: "TestBody", date: .now))
        sut.deleteNotes(by: nil)

        XCTAssertFalse(
            presenterMock.updateNotesWasCalled,
            "Interactor mustn't call Presenter's method updateNotes"
        )
        XCTAssertTrue(
            presenterMock.alertNoSelectedNoteWasCalled,
            "Interactor must call Presenter's method alertNoSelectedNote, because note's id is nil"
        )
        XCTAssertFalse(sut.notes.isEmpty, "Interactors's data store mustn't be empty")
    }

    func testsDeleteNotesWithNegativeId() {
        sut.notes.append(Note(title: "testTitle", text: "TestBody", date: .now))
        sut.deleteNotes(by: .init(id: -1))

        XCTAssertFalse(
            presenterMock.updateNotesWasCalled,
            "Interactor mustn't call Presenter's method updateNotes"
        )
        XCTAssertTrue(
            presenterMock.alertNoSelectedNoteWasCalled,
            "Interactor must call Presenter's method alertNoSelectedNote, because note's id is negative"
        )
        XCTAssertFalse(sut.notes.isEmpty, "Interactors's data store mustn't be empty")
    }

    func testsDeleteNotesWithNoteIdMoreThenDataStoreCapacity() {
        sut.notes.append(Note(title: "testTitle", text: "TestBody", date: .now))
        sut.deleteNotes(by: .init(id: 10))

        XCTAssertFalse(
            presenterMock.updateNotesWasCalled,
            "Interactor mustn't call Presenter's method updateNotes"
        )
        XCTAssertTrue(
            presenterMock.alertNoSelectedNoteWasCalled,
            "Interactor must call Presenter's method alertNoSelectedNote, because note's id out of range"
        )
        XCTAssertFalse(sut.notes.isEmpty, "Interactors's data store mustn't be empty")
    }

    func testsSaveNotes() {
        sut.notes.append(Note(title: "testTitle", text: "TestBody", date: .now))
        sut.saveNotes()

        XCTAssertTrue(
            dataProvider.saveNotesWasCalled,
            "Interactor must call dataProvider's method saveNotes"
        )
    }
}
