//
//  SelectBarButtonItem.swift
//  Notes
//
//  Created by Nikita Yakovlev on 07.05.2022.
//

import UIKit
import Foundation
enum ButtonState {
    case done, selecting

    mutating func toggle() {
        switch self {
        case .done:
            self = .selecting
        case .selecting:
            self = .done
        }
    }

    func getNextStateText() -> String {
        switch self {
        case .done:
            return NSLocalizedString("selectButton", comment: "")
        case .selecting:
            return NSLocalizedString("doneButton", comment: "")
        }
    }
}

class SelectBarButtonItem: UIBarButtonItem {
    var stateButton: ButtonState = .done {
        didSet {
        self.title = stateButton.getNextStateText()
        }
    }

    override init() {
        super.init()
        self.title = stateButton.getNextStateText()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
