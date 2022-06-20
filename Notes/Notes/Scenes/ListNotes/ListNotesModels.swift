//
//  ListNotesModels.swift
//  Notes
//
//  Created by Nikita Yakovlev on 05.06.2022.
//
import Foundation

enum ListNotes {
    struct PreviewNote {
        var title: String
        var text: String
        var date: String
        var userShareIcon: URL?
    }
    typealias NoteDispalyed = Note

    // MARK: Use cases

    enum FetchNotes {
        struct Request {
            var getFromStorage: Bool
        }

        struct Response {
            var notes: [NoteDispalyed]
        }

        struct ViewModel {
            var displayedNotes: [PreviewNote]
        }
    }

    enum DeleteNotes {
        struct Request {
            var id: Int
        }

        struct Response {
            var notes: [NoteDispalyed]
        }

        struct ViewModel {
            var updatedNotes: [PreviewNote]
        }
    }

    enum AlertErrors {
        enum AlertError: String {
            case notSelectedNotes
        }

        struct Response {
            var error: AlertError
        }

        struct ViewModel {
            var message: String
        }
    }
}
