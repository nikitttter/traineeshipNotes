//
//  NoteCellView.swift
//  Notes
//
//  Created by Nikita Yakovlev on 09.04.2022.
//

import UIKit

class NoteCellView: UIView {
    private let titleField = UILabel()
    private let textField = UILabel()
    private let dateField = UILabel()
    private var model: Note?
    var dateFormat = "dd.MM.yyyy"
    var closure: ((Note) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setData(_ note: Note) {
        model = note
        titleField.text = note.title
        textField.text = note.text
        dateField.setText(date: note.date, format: dateFormat)
    }

    private func setupView() {
        setupTitleField()
        setupTextField()
        setupDateField()

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(recognizer)
        self.clipsToBounds = true
        self.layer.cornerRadius = 14.0
        self.backgroundColor = .white
    }

    private func setupTitleField() {
        self.addSubview(titleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        titleField.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        titleField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        titleField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -42.0).isActive = true

        titleField.isUserInteractionEnabled = false

        titleField.font = .systemFont(ofSize: 16.0)
        titleField.textColor = .black
    }

    private func setupTextField() {
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 4.0).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true

        textField.isUserInteractionEnabled = false

        textField.font = UIFont.systemFont(ofSize: 10.0)
        textField.textColor = UIColor.lightGray
    }

    private func setupDateField() {
        self.addSubview(dateField)
        dateField.translatesAutoresizingMaskIntoConstraints = false
        dateField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24.0).isActive = true
        dateField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        dateField.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
        dateField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true

        dateField.isUserInteractionEnabled = false

        dateField.font = UIFont.systemFont(ofSize: 10.0)
        dateField.textColor = UIColor.black
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let note = self.model {
            closure?(note)
        }
    }
}

extension UILabel {
    fileprivate func setText(date: Date, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        self.text = formatter.string(from: date)
    }
}
