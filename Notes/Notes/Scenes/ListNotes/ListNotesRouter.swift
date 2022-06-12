//
//  ListNotesRouter.swift
//  Notes
//
//  Created by Nikita Yakovlev on 05.06.2022.
//

import Foundation
import UIKit

protocol ListNotesRoutingLogic {
    func routeToNoteDetailsForEditing(at id: Int?)
}

protocol ListNotesDataPassing {
    var dataStore: ListNotesDataStore { get set }
}

class ListNotesRouter: ListNotesDataPassing {
    weak var viewController: ListNotesViewController?
    var dataStore: ListNotesDataStore

    // MARK: object lifecycle

    init( interactor: ListNotesDataStore) {
        self.dataStore = interactor
    }

    private func passDataToNoteDetails(
        source: ListNotesDataStore,
        idNote: Int?,
        destination: inout NoteDataStore
    ) {
        guard idNote != nil, source.notes != nil else { return }
        destination.note = source.notes![idNote!]
    }
}

// MARK: ListNotesRoutingLogic

extension ListNotesRouter: ListNotesRoutingLogic {
    func routeToNoteDetailsForEditing(at id: Int?) {
        let destinationViewController = NoteAssembly.build()
        var destinationDataSource = destinationViewController.router.dataStore

        passDataToNoteDetails(source: dataStore, idNote: id, destination: &destinationDataSource)

        viewController?.navigationItem.title = ""
        viewController?.show(destinationViewController, sender: nil)
    }
}
