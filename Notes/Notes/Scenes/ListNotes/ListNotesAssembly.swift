//
//  ListNotesAssembly.swift
//  Notes
//
//  Created by Nikita Yakovlev on 13.06.2022.
//

import UIKit

enum ListNotesAssembly {
    static private var listViewController: ListNotesViewController?

    static func build() -> ListNotesViewController {
        if listViewController == nil {
            let presenter = ListNotesPresenter()
            let worker = Worker()
            let dataProvider = NoteArrayDataProvider.getInstance()
            let interactor = ListNotesInteractor(presenter: presenter, worker: worker, dataProvider: dataProvider)
            let router = ListNotesRouter(interactor: interactor)
            let viewController = ListNotesViewController(interactor: interactor, router: router)

            presenter.viewController = viewController
            router.viewController = viewController
            listViewController = viewController
        }

        return listViewController!
    }
}
