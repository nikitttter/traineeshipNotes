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

            self.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
            self.layer.borderWidth = 0.0
            self.contentView.backgroundColor = UIColor.white
            self.contentView.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor

        case false:
            self.clipsToBounds = true
            self.layer.cornerRadius = 14.0
            self.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor

            self.backgroundColor = UIColor.white
            self.layer.borderWidth = 2.0
            self.contentView.backgroundColor = .clear
            self.contentView.layer.borderColor = UIColor.clear.cgColor
        }
    }

    private func setupTitleField() {
        self.contentView.addSubview(titleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.topAnchor.constraint(
            equalTo: self.contentView.topAnchor,
            constant: 10.0
        ).isActive = true
        titleField.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        titleField.leadingAnchor.constraint(
            equalTo: self.contentView.leadingAnchor,
            constant: 16.0
        ).isActive = true

        titleField.isUserInteractionEnabled = false

        titleField.font = .systemFont(ofSize: 16.0)
        titleField.textColor = .black
    }

    private func setupTextField() {
        self.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(
            equalTo: titleField.bottomAnchor,
            constant: 4.0
        ).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        textField.leadingAnchor.constraint(
            equalTo: self.contentView.leadingAnchor,
            constant: 16.0
        ).isActive = true

        textField.isUserInteractionEnabled = false

        textField.font = UIFont.systemFont(ofSize: 10.0)
        textField.textColor = UIColor.lightGray
    }

    private func setupDateField() {
        self.contentView.addSubview(dateField)
        dateField.translatesAutoresizingMaskIntoConstraints = false
        dateField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24.0).isActive = true
        dateField.bottomAnchor.constraint(
            equalTo: self.contentView.bottomAnchor,
            constant: -10
        ).isActive = true
        dateField.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
        dateField.leadingAnchor.constraint(
            equalTo: self.contentView.leadingAnchor,
            constant: 16.0
        ).isActive = true

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
