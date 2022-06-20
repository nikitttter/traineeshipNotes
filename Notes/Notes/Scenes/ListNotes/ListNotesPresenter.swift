//
//  ListNotesPresenter.swift
//  Notes
//
//  Created by Nikita Yakovlev on 05.06.2022.
//

import Foundation

protocol ListNotesPresentationLogic {
    func presentNotes(response: ListNotes.FetchNotes.Response)
    func deleteNotes(response: ListNotes.DeleteNotes.Response)
    func alertNoSelectedNote(response: ListNotes.AlertErrors.Response)
}

class ListNotesPresenter {
    weak var viewController: ListNotesDisplayLogic?

    private let dateFormatted: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}

// MARK: ListNotesPresentationLogic

extension ListNotesPresenter: ListNotesPresentationLogic {
    func presentNotes(response: ListNotes.FetchNotes.Response) {
        let displayedNotes = response.notes.map {
            return ListNotes.PreviewNote(
                title: $0.title,
                text: $0.text,
                date: dateFormatted.string(from: $0.date),
                userShareIcon: $0.userShareIcon
            )
        }
        let viewModel = ListNotes.FetchNotes.ViewModel(displayedNotes: displayedNotes)
        viewController?.displayData(viewModel)
    }

    func deleteNotes(response: ListNotes.DeleteNotes.Response) {
        let updatedNotes = response.notes.map {
            return ListNotes.PreviewNote(
                title: $0.title,
                text: $0.text,
                date: dateFormatted.string(from: $0.date),
                userShareIcon: $0.userShareIcon
            )
        }
        let viewModel = ListNotes.DeleteNotes.ViewModel(updatedNotes: updatedNotes)
        viewController?.updateKeepData(viewModel)
    }

    func alertNoSelectedNote(response: ListNotes.AlertErrors.Response) {
        let message = NSLocalizedString(response.error.rawValue, comment: "")
        let viewModel = ListNotes.AlertErrors.ViewModel(message: message)
        viewController?.showAlert(viewModel)
    }
}
