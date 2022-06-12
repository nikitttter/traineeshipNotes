//
//  NoteAssembly.swift
//  Notes
//
//  Created by Nikita Yakovlev on 13.06.2022.
//

import UIKit

enum NoteAssembly {
    static func build() -> NoteDetailsViewController {
        let presenter = NotePresenter()
        let interactor = NoteInteractor(presenter: presenter)
        let router = NoteRouter(interactor: interactor)
        let viewController = NoteDetailsViewController(interactor: interactor, router: router)

        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
