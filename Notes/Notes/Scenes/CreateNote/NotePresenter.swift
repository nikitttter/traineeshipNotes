//
//  NotePresenter.swift
//  Notes
//
//  Created by Nikita Yakovlev on 13.06.2022.
//

import Foundation

protocol NotePresentationLogic {
    func presentNoteDetails(response: NoteDetails.ShowNoteDetails.Response)
    func showAlert(response: NoteDetails.UpdateNoteModel.Response)
}

class NotePresenter {
    weak var viewController: NoteDisplayLogic?

    private let dateFormatted: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy EEEE HH:mm"
        return formatter
    }()
}

// MARK: NotePresentationLogic

extension NotePresenter: NotePresentationLogic {
    func presentNoteDetails(response: NoteDetails.ShowNoteDetails.Response) {
        let dateString = dateFormatted.string(from: response.noteDate)

        let viewModel = NoteDetails.ShowNoteDetails.ViewModel(
            noteHeader: response.noteHeader,
            noteText: response.noteText,
            noteDate: dateString
        )
        viewController?.displayNoteDetails(viewModel: viewModel)
    }

    func showAlert(response: NoteDetails.UpdateNoteModel.Response) {
        let message = NSLocalizedString(response.error.rawValue, comment: "")
        let viewModel = NoteDetails.UpdateNoteModel.ViewModel(message: message)
        viewController?.showAlert(viewModel: viewModel)
    }
}
