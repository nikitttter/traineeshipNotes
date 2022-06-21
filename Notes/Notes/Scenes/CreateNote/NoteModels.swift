//
//  NoteModels.swift
//  Notes
//
//  Created by Nikita Yakovlev on 13.06.2022.
//

import Foundation

enum NoteDetails {
    // MARK: Use cases
    enum ShowNoteDetails {
        struct Response {
            var noteHeader: String
            var noteText: String
            var noteDate: Date
        }

        struct ViewModel {
            var noteHeader: String
            var noteText: String
            var noteDate: String
        }
    }

    enum UpdateNoteModel {
        enum AlertError: String {
            case emptyNote
        }

        struct Request {
            var noteHeader: String?
            var noteText: String?
        }

        struct Response {
            var error: AlertError
        }

        struct ViewModel {
            var message: String
        }
    }

    enum SaveNoteModel {
        struct Request {
            var noteHeader: String?
            var noteText: String?
        }
    }
}
