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
    private let container = UIView()
    private let content = UIView()
    private let checkBox = UICheckBox()

    private var model: Note?
    var dateFormat = "dd.MM.yyyy"
    var closure: ((Note) -> Void)?

    private var normalLayoutLeadinfCell: NSLayoutConstraint?

    private let spacingDeleteControl = CGFloat(40)
    var checked: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

    private func setupView() {
        setupContainer()
        setupContent()
        setupTitleField()
        setupTextField()
        setupDateField()

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        container.addGestureRecognizer(recognizer)

        self.clipsToBounds = true
        self.layer.cornerRadius = 14.0
        self.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        self.container.clipsToBounds = true
        self.container.layer.cornerRadius = 14

        self.content.clipsToBounds = true
        self.content.layer.cornerRadius = 14
    }
    func setupContainer() {
        self.contentView.addSubview(container)
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.container.bottomAnchor.constraint(
            equalTo: self.contentView.bottomAnchor,
            constant: -4
        ).isActive = true
        self.container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true

        container.backgroundColor = .white
    }

    private func setupContent() {
        self.container.addSubview(content)
        self.content.translatesAutoresizingMaskIntoConstraints = false
        self.content.rightAnchor.constraint(equalTo: self.container.rightAnchor).isActive = true
        self.content.topAnchor.constraint(equalTo: self.container.topAnchor).isActive = true
        self.content.bottomAnchor.constraint(
            equalTo: self.contentView.bottomAnchor
        ).isActive = true

        normalLayoutLeadinfCell = self.content.leftAnchor.constraint(equalTo: self.container.leftAnchor)
        normalLayoutLeadinfCell?.isActive = true
    }

    private func setupTitleField() {
        self.content.addSubview(titleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.topAnchor.constraint(
            equalTo: self.content.topAnchor,
            constant: 10.0
        ).isActive = true
        titleField.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        titleField.leadingAnchor.constraint(
            equalTo: self.content.leadingAnchor,
            constant: 16.0
        ).isActive = true
        titleField.trailingAnchor.constraint(
            equalTo: self.content.trailingAnchor,
            constant: -42.0
        ).isActive = true

        titleField.isUserInteractionEnabled = false

        titleField.font = .systemFont(ofSize: 16.0)
        titleField.textColor = .black
    }

    private func setupTextField() {
        self.content.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(
            equalTo: titleField.bottomAnchor,
            constant: 4.0
        ).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        textField.leadingAnchor.constraint(
            equalTo: self.content.leadingAnchor,
            constant: 16.0
        ).isActive = true
        textField.trailingAnchor.constraint(
            equalTo: self.content.trailingAnchor,
            constant: -16.0
        ).isActive = true

        textField.isUserInteractionEnabled = false

        textField.font = UIFont.systemFont(ofSize: 10.0)
        textField.textColor = UIColor.lightGray
    }

    private func setupDateField() {
        self.content.addSubview(dateField)
        dateField.translatesAutoresizingMaskIntoConstraints = false
        dateField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24.0).isActive = true
        dateField.bottomAnchor.constraint(
            equalTo: self.content.bottomAnchor,
            constant: -10
        ).isActive = true
        dateField.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
        dateField.leadingAnchor.constraint(
            equalTo: self.content.leadingAnchor,
            constant: 16.0
        ).isActive = true

        dateField.isUserInteractionEnabled = false

        dateField.font = UIFont.systemFont(ofSize: 10.0)
        dateField.textColor = UIColor.black
    }

    private func setupCheckBox() {
        container.addSubview(checkBox)
        checkBox.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        checkBox.centerXAnchor.constraint(
            equalTo: container.leadingAnchor,
            constant: normalLayoutLeadinfCell!.constant + 20 // 40 / 2
        ).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkBox.alpha = 0.0
        checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchDown)
        checkBox.checked = false
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let note = self.model {
            closure?(note)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        if editing {
            setupCheckBox()
            setVisibleCheckBoxAnimated(true, animated: animated, completion: nil)
        } else {
            setVisibleCheckBoxAnimated(false, animated: animated) { [weak self] in
                self?.checkBox.removeFromSuperview()
            }
        }
    }

    private func setVisibleCheckBoxAnimated(_ visible: Bool, animated: Bool, completion: (() -> Void)?) {
        guard let constraintValue = self.normalLayoutLeadinfCell?.constant else {
            return
        }

        let alpha = visible ? 1.0 : 0.0
        let targetConstraintValue = visible ? constraintValue + spacingDeleteControl : 0.0

        let durationFirstAnim = animated ? 1.0 : 0.0

        let durationSecondAnim = animated ? 0.5 : 0.0

        if visible { self.layoutIfNeeded() }

        UIView.animate(withDuration: durationFirstAnim) { [weak self] in
            self?.normalLayoutLeadinfCell?.constant = targetConstraintValue
            if animated { self?.layoutIfNeeded() }
        }

        UIView.animate(
            withDuration: durationSecondAnim,
            delay: 0.0,
            options: [],
            animations: {
                self.checkBox.alpha = alpha
            },
            completion: { _ in
                completion?()
            }
        )
    }

    @objc private func checkBoxTapped() {
        checked = !checked
    }
}

private extension UILabel {
    func setText(date: Date, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        self.text = formatter.string(from: date)
    }
}
