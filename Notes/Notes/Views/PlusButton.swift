//
//  plusButton.swift
//  Notes
//
//  Created by Nikita Yakovlev on 10.04.2022.
//

import UIKit

class PlusButton: UIButton {
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
        self.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        self.setTitle("+", for: .normal)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.font = .systemFont(ofSize: 36.0)
        self.titleLabel?.textAlignment = .center
        self.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}
