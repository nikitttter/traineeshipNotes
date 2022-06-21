//
//  SelectBarButtonItem.swift
//  Notes
//
//  Created by Nikita Yakovlev on 07.05.2022.
//

import UIKit
import Foundation

class SelectBarButtonItem: UIBarButtonItem {
    var stateButton: ItemState = .main {
        didSet {
            self.title = getNextStateText()
        }
    }

   private func getNextStateText() -> String {
        switch stateButton {
        case .main:
            return NSLocalizedString("selectButton", comment: "")
        case .additional:
            return NSLocalizedString("doneButton", comment: "")
        }
    }
    override init() {
        super.init()
        print("class SelectBarButtonItem has been initialized")
        self.title = getNextStateText()
    }

    deinit {
        print("class SelectBarButtonItem has been deallocated")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
