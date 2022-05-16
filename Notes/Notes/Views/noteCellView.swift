//
//  NoteCellView.swift
//  Notes
//
//  Created by Nikita Yakovlev on 09.04.2022.
//

import UIKit

class NoteCellView: UITableViewCell {
    private let titleField = UILabel()
    private let textField = UILabel()
    private let dateField = UILabel()

    private var model: Note?
    var dateFormat = "dd.MM.yyyy"

    private let borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    private let bodyBackgroundColor = UIColor.white

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupTitleField()
        setupTextField()
        setupDateField()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ note: Note) {
        model = note
        titleField.text = note.title
        textField.text = note.text
        dateField.setText(date: note.date, format: dateFormat)
    }

    func setupView(editing: Bool = false) {
        switch editing {
        case true:
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 14.0
            self.contentView.layer.borderWidth = 2.0

            self.backgroundColor = borderColor
            self.layer.borderWidth = 0.0
            self.contentView.backgroundColor = bodyBackgroundColor
            self.contentView.layer.borderColor = borderColor.cgColor

        case false:
            self.clipsToBounds = true
            self.layer.cornerRadius = 14.0
            self.layer.borderColor = borderColor.cgColor

            self.backgroundColor = bodyBackgroundColor
            self.layer.borderWidth = 2.0
            self.contentView.backgroundColor = bodyBackgroundColor
            self.contentView.layer.borderColor = bodyBackgroundColor.cgColor
        }
    }

    private func setupTitleField() {
        self.contentView.addSubview(titleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0),
            titleField.heightAnchor.constraint(equalToConstant: 18.0),
            titleField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0)
        ])

        titleField.isUserInteractionEnabled = false

        titleField.font = .systemFont(ofSize: 16.0)
        titleField.textColor = .black
    }

    private func setupTextField() {
        self.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 4.0),
            textField.heightAnchor.constraint(equalToConstant: 14.0),
            textField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0)
        ])

        textField.isUserInteractionEnabled = false

        textField.font = UIFont.systemFont(ofSize: 10.0)
        textField.textColor = UIColor.lightGray
    }

    private func setupDateField() {
        self.contentView.addSubview(dateField)
        dateField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dateField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24.0),
            dateField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            dateField.heightAnchor.constraint(equalToConstant: 10.0),
            dateField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0)
        ])

        dateField.isUserInteractionEnabled = false

        dateField.font = UIFont.systemFont(ofSize: 10.0)
        dateField.textColor = UIColor.black
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)

        if self.editingStyle == .delete {
            setupView(editing: editing)
        }
    }
}

private extension UILabel {
    func setText(date: Date, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        self.text = formatter.string(from: date)
    }
}
