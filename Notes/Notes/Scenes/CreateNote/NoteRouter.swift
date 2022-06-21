//
//  NoteRouter.swift
//  Notes
//
//  Created by Nikita Yakovlev on 13.06.2022.
//

import Foundation
import UIKit

protocol NoteRoutingLogic {
    func routeToNotesList()
}

protocol NoteDataPassing {
    var dataStore: NoteDataStore { get set }
}

class NoteRouter: NoteDataPassing {
    weak var viewController: NoteDetailsViewController?
    var dataStore: NoteDataStore

    init (interactor: NoteDataStore) {
        self.dataStore = interactor
    }

    private func passDataToNotesList(
        source: NoteDataStore,
        destination: inout ListNotesDataStore
    ) {
        guard let note = source.note else { return }
        if let index = destination.notes?.firstIndex(where: { $0.id == note.id }) {
            switch note.isEmpty {
            case true:
                destination.notes?.remove(at: index)
            case false:
                if destination.notes![index].online {
                    destination.notes![index] = note.getOnlineNote()
                } else {
                    destination.notes![index] = note
                }
            }
        } else {
            if !note.isEmpty {
                destination.notes?.append(note)
            }
        }
    }
}

// MARK: NoteRoutingLogic

extension NoteRouter: NoteRoutingLogic {
    func routeToNotesList() {
        let destination = ListNotesAssembly.build()
        var destinationDataSource = destination.router.dataStore
        passDataToNotesList(source: dataStore, destination: &destinationDataSource)
    }
}
