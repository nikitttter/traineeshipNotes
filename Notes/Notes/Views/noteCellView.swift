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

    private let bodyBackgroundColor = UIColor.white
    private var circleMask: CAShapeLayer?
    private let verticalPadding = 2.0

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

    func setupView() {
            self.backgroundColor = bodyBackgroundColor
    }

    private func setupTitleField() {
        self.contentView.addSubview(titleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: 10.0 + verticalPadding
            ),
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
            dateField.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -10.0 - verticalPadding
            ),
            dateField.heightAnchor.constraint(equalToConstant: 10.0),
            dateField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0)
        ])

        dateField.isUserInteractionEnabled = false

        dateField.font = UIFont.systemFont(ofSize: 10.0)
        dateField.textColor = UIColor.black
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        if self.isEditing && self.isEditing == editing {
            self.isEditing = false
        }

        super.setEditing(editing, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if circleMask == nil {
            circleMask = CAShapeLayer()
            circleMask!.path = UIBezierPath(roundedRect: CGRect(
                x: self.bounds.minX,
                y: self.bounds.minY,
                width: self.frame.width,
                height: self.frame.height - (verticalPadding * 2)
            ), cornerRadius: 14.0).cgPath

            self.layer.mask = circleMask
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
