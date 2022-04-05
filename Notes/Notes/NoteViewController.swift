//
//  ViewController.swift
//  Notes
//
//  Created by Nikita Yakovlev on 27.03.2022.
//

import UIKit
import Foundation

class NoteViewController: UIViewController {
    private let titleTextField = UITextField()
    private let doneButton = UIBarButtonItem()
    private let noteTextField = UITextView()
    private let headerContainer = UIView()
    private let dateField = UITextField()
    private let datePicker = UIDatePicker()

    private let dateFormatted = DateFormatter()
    private var datePickerWasShown = false
    private var dateFieldBottomAnchor: NSLayoutConstraint?
    private var note = Note()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray
        dateFormatted.setLocalizedDateFormatFromTemplate("dd MMMM yyyy")
        setupDoneButton()
        setupHeaderContainer()
        setupNoteField()

        titleTextField.text = note.title
        noteTextField.text = note.text
        if let date = note.date {
            datePicker.date = date
            dateField.text = "\(NSLocalizedString("date", comment: "")): \(dateFormatted.string(from: datePicker.date))"
        }
    }

    private func setupHeaderContainer() {
        view.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false

        headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerContainer.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 5
        ).isActive = true
        headerContainer.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -5
        ).isActive = true

        headerContainer.addSubview(titleTextField)
        headerContainer.addSubview(dateField)

        setupTitleField()
        setupDateField()
        setupDatePicker()
    }

    private func setupTitleField() {
        guard let superView = titleTextField.superview else {
            return
        }
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -20).isActive = true

        titleTextField.placeholder = NSLocalizedString("noteTitlePlaceHolder", comment: "")
        titleTextField.font = UIFont.boldSystemFont(ofSize: 22.0)
    }

    private func setupDoneButton() {
        doneButton.title = NSLocalizedString("doneButton", comment: "")
        doneButton.target = self
        doneButton.action = #selector(doneButtonTapped(_:))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func setupNoteField() {
        view.addSubview(noteTextField)
        noteTextField.translatesAutoresizingMaskIntoConstraints = false

        noteTextField.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 20).isActive = true
        noteTextField.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 5
        ).isActive = true
        noteTextField.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -5
        ).isActive = true
        noteTextField.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -20
        ).isActive = true

        noteTextField.font = UIFont.systemFont(ofSize: 14.0)
        noteTextField.backgroundColor = UIColor.black.withAlphaComponent(0.2)

        noteTextField.becomeFirstResponder()
    }

    private func setupDateField() {
        guard let superView = dateField.superview else {
            return
        }

        dateField.translatesAutoresizingMaskIntoConstraints = false
        dateField.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        dateField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true

        dateFieldBottomAnchor = dateField.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        dateFieldBottomAnchor?.isActive = !datePickerWasShown

        dateField.backgroundColor = UIColor.gray
        dateField.font = UIFont.systemFont(ofSize: 16)
        dateField.textColor = UIColor.black
        dateField.textAlignment = .center

        let placeholderAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        dateField.attributedPlaceholder = NSAttributedString(
            string: "\(NSLocalizedString("date", comment: "")): \(dateFormatted.string(from: Date.now))",
            attributes: placeholderAttributes
        )

        dateField.delegate = self
        dateField.addTarget(self, action: #selector(dateFieldTapped), for: .touchDown)
    }

    private func setupDatePicker() {
        guard let superView = datePicker.superview else {
            return
        }

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -20).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 20).isActive = true

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_ :)), for: .valueChanged)
    }

    override func viewDidLayoutSubviews() {
        noteTextField.layer.masksToBounds = true
        noteTextField.layer.cornerRadius = noteTextField.smallerSide / 30

        dateField.layoutIfNeeded()
        dateField.layer.masksToBounds = true
        dateField.layer.cornerRadius = dateField.frame.height / 4
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasShowen),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWasHidden),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func hideKeyboard() {
        titleTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()
    }

    private func hideDatePicker() {
        datePicker.removeFromSuperview()
        dateFieldBottomAnchor?.isActive = true
        datePickerWasShown = false
    }

    private func showDatePicker() {
        headerContainer.addSubview(datePicker)
        dateFieldBottomAnchor?.isActive = false
        setupDatePicker()
        datePickerWasShown = true
    }

    func showErrorAlert(_ text: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("error", comment: ""),
            message: text,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func doneButtonTapped(_ sender: Any) {
        note.title = titleTextField.text ?? ""
        note.text = noteTextField.text
        note.date = dateField.text == "" ? nil : datePicker.date

        guard !self.isNoteEmpty() else {
            showErrorAlert(NSLocalizedString("emptyNote", comment: ""))
            return
        }

        note.save()
        hideDatePicker()
        hideKeyboard()
    }

    @objc private func keyboardWasShowen(_ notification: Notification) {
        guard let info = notification.userInfo as NSDictionary? else {
            return
        }
        guard let keyboardSize = (
            info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size else {
            return
        }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        noteTextField.contentInset = contentInsets
    }

    @objc private func keyboardWasHidden(_ notification: Notification) {
        noteTextField.contentInset = UIEdgeInsets.zero
    }

    @objc private func dateFieldTapped() {
        hideKeyboard()

        if datePickerWasShown {
            hideDatePicker()
        } else {
            showDatePicker()
            dateField.text = nil
        }
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        dateField.text = "\(NSLocalizedString("date", comment: "")): \(dateFormatted.string(from: sender.date))"
    }
}

extension UITextView {
    var smallerSide: CGFloat {
        return self.frame.width < self.frame.height ? self.frame.width : self.frame.height
    }
}

extension NoteViewController {
    func isNoteEmpty() -> Bool {
        return note.isEmpty
    }
}

extension NoteViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateField {
            return false
        }
        return true
    }
}
