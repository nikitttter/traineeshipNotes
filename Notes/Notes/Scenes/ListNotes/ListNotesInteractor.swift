//
//  ListNotesInteractor.swift
//  Notes
//
//  Created by Nikita Yakovlev on 05.06.2022.
//

import Foundation
import UIKit

protocol ListNotesBusinesLogic {
    func fetchNotes()
    func deleteNotes(by index: ListNotes.UpdatedNotes.Request?)
    func saveNotes()
}

protocol ListNotesDataStore {
    var notes: [Note]? { get set }
}

class ListNotesInteractor: ListNotesDataStore {
    private let presenter: ListNotesPresentationLogic
    private let worker: WorkerType

    var notes: [Note]?

    // MARK: object lifecycle

    init (presenter: ListNotesPresentationLogic, worker: WorkerType) {
        self.presenter = presenter
        self.worker = worker
    }
}

// MARK: ListNotesBusinesLogic

extension ListNotesInteractor: ListNotesBusinesLogic {
    func fetchNotes() {
        if notes == nil {
            notes = NoteArrayDataProvider.getInstance().getSavedNotes()

            worker.fetchData { fetchedNotes in
                self.notes?.append(contentsOf: fetchedNotes)
                let response = ListNotes.FetchNotes.Response(notes: self.notes ?? [Note]())
                self.presenter.presentNotes(response: response)
            }
        }
        let response = ListNotes.FetchNotes.Response(notes: notes ?? [Note]())
        presenter.presentNotes(response: response)
    }

    func deleteNotes(by index: ListNotes.UpdatedNotes.Request?) {
        if let index = index {
            notes?.remove(at: index.id)
            let response = ListNotes.UpdatedNotes.Response(notes: notes ?? [Note]())
            presenter.updateNotes(response: response)
        } else {
            let response = ListNotes.AlertErrors.Response(error: .notSelectedNotes)
            presenter.alertNoSelectedNote(response: response)
        }
    }

    func saveNotes() {
        if let notes = notes {
            NoteArrayDataProvider.getInstance().saveNotes(notes.filter({
                !$0.online
            }))
        }
    }
}
