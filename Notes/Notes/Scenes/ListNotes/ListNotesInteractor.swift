//
//  ListNotesInteractor.swift
//  Notes
//
//  Created by Nikita Yakovlev on 05.06.2022.
//

import Foundation
import UIKit

protocol ListNotesBusinesLogic {
    func fetchNotes(_ update: ListNotes.FetchNotes.Request)
    func fetchOnlineNotes()
    func deleteNotes(by index: ListNotes.DeleteNotes.Request?)
    func saveNotes()
}

protocol ListNotesDataStore {
    var notes: [Note] { get set }
}

class ListNotesInteractor: ListNotesDataStore {
    private let presenter: ListNotesPresentationLogic
    private let worker: WorkerType

    var notes: [Note]

    var dataProvider: NoteStorage

    // MARK: object lifecycle

    init (presenter: ListNotesPresentationLogic, worker: WorkerType, dataProvider: NoteStorage) {
        self.presenter = presenter
        self.worker = worker
        self.dataProvider = dataProvider
        self.notes = [Note]()
    }
}

// MARK: ListNotesBusinesLogic

extension ListNotesInteractor: ListNotesBusinesLogic {
    func fetchOnlineNotes() {
        worker.fetchData { fetchedNotes in
            self.notes.removeAll { $0.online }
            self.notes.append(contentsOf: fetchedNotes)
            let response = ListNotes.FetchNotes.Response(notes: self.notes)
            self.presenter.presentNotes(response: response)
        }
    }

    func fetchNotes(_ update: ListNotes.FetchNotes.Request) {
        if update.getFromStorage == true {
            if let savedNotes = dataProvider.getSavedNotes() {
                notes.removeAll { $0.online == false }
                notes.append(contentsOf: savedNotes)
            }
        }
        let response = ListNotes.FetchNotes.Response(notes: notes)
        presenter.presentNotes(response: response)
    }

    func deleteNotes(by index: ListNotes.DeleteNotes.Request?) {
        if let index = index, index.id >= 0, notes.count > index.id {
            notes.remove(at: index.id)
            let response = ListNotes.DeleteNotes.Response(notes: notes)
            presenter.updateNotes(response: response)
        } else {
            let response = ListNotes.AlertErrors.Response(error: .notSelectedNotes)
            presenter.alertNoSelectedNote(response: response)
        }
    }

    func saveNotes() {
        dataProvider.saveNotes(notes.filter({
            $0.online == false
        }))
    }
}
