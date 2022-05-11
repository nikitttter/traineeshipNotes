//
//  plusButton.swift
//  Notes
//
//  Created by Nikita Yakovlev on 10.04.2022.
//

import UIKit

class PlusButton: UIButton {
    var stateButton: ItemState = .main {
        didSet {
            let nameImage: String = stateButton == .main ? "AddButton" : "RemoveButton"
            self.setImage(UIImage(named: nameImage), for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSetting()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSetting()
    }

    private func setupSetting() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(named: "AddButton"), for: .normal)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.font = .systemFont(ofSize: 36.0)
        self.titleLabel?.textAlignment = .center
        self.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.contentVerticalAlignment = .bottom
    }
}
