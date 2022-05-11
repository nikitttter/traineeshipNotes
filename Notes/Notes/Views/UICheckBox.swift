//
//  UICheckBox.swift
//  Notes
//
//  Created by Nikita Yakovlev on 11.05.2022.
//

import UIKit

class UICheckBox: UIButton {
    var checked: Bool = false {
        didSet {
            if checked {
                self.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            } else {
                self.backgroundColor = .clear
            }
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
        self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1

        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(buttonTapped))
        self.addGestureRecognizer(recognizer)
    }

    @objc private func buttonTapped() {
        checked = !checked
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
