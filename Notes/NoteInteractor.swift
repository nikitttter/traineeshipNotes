//
//  NoteInteractor.swift
//  Notes
//
//  Created by Nikita Yakovlev on 13.06.2022.
//

import Foundation

protocol NoteBusinesLogic {
    func provideNoteDetail()
    func updateNoteDetail(request: NoteDetails.UpdateNoteModel.Request)
    func saveNotes(request: NoteDetails.SaveNoteModel.Request)
}

protocol NoteDataStore {
    var note: Note? { get set }
    var isEditingNote: Bool { get }
}

class NoteInteractor: NoteDataStore {
    private let presenter: NotePresentationLogic

    var note: Note?
    lazy var isEditingNote = (note != nil) ? true : false

    init (presenter: NotePresentationLogic) {
        self.presenter = presenter
    }

    private func prepareNote(title: String?, text: String?) {
        let idNote = note?.id

        note = Note(
            title: title ?? "",
            text: text ?? "",
            date: Date.now,
            userShareIcon: note?.userShareIcon
        )
        if let id = idNote {
            note?.setId(id)
        }
    }
}

// MARK: NoteBusinesLogic

extension NoteInteractor: NoteBusinesLogic {
    func updateNoteDetail(request: NoteDetails.UpdateNoteModel.Request) {
        prepareNote(title: request.noteHeader, text: request.noteText)

        if note!.isEmpty == false {
            provideNoteDetail()
        } else {
            let response = NoteDetails.UpdateNoteModel.Response(error: .emptyNote)
            presenter.showAlert(response: response)
        }
    }

    func provideNoteDetail() {
        let response = NoteDetails.ShowNoteDetails.Response(
            noteHeader: note?.title ?? "",
            noteText: note?.text ?? "",
            noteDate: note?.date ?? Date.now
        )

        presenter.presentNoteDetails(response: response)
    }

    func saveNotes(request: NoteDetails.SaveNoteModel.Request) {
        prepareNote(title: request.noteHeader, text: request.noteText)
        presenter.disappearView()
    }
}
