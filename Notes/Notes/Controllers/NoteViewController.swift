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
    private var currentDate = Date.now

    private let dateFormatted = DateFormatter()
    private var isNewNote: Bool!
    var data: Note?
    weak var delegate: ListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        dateFormatted.dateFormat = "dd.MM.yyyy EEEE HH:mm"
        setupDoneButton()
        setupHeaderContainer()
        setupNoteField()

        if data != nil {
            isNewNote = false
        } else {
            isNewNote = true
        }

        titleTextField.text = data?.title
        noteTextField.text = data?.text
        dateField.text = dateFormatted.string(from: currentDate)
     }

    private func setupHeaderContainer() {
        view.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false

        headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerContainer.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor
        ).isActive = true
        headerContainer.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor
        ).isActive = true

        headerContainer.addSubview(titleTextField)
        headerContainer.addSubview(dateField)

        setupDateField()
        setupTitleField()
    }

    private func setupTitleField() {
        guard let superView = titleTextField.superview else {
            return
        }
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 20.0).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20.0).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -70.0).isActive = true
        titleTextField.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true

        titleTextField.placeholder = NSLocalizedString("noteTitlePlaceHolder", comment: "")
        titleTextField.font = UIFont.boldSystemFont(ofSize: 24.0)

        titleTextField.delegate = self
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

        noteTextField.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 16.0).isActive = true
        noteTextField.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 20.0
        ).isActive = true
        noteTextField.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -20.0
        ).isActive = true
        noteTextField.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -20.0
        ).isActive = true

        noteTextField.font = UIFont.systemFont(ofSize: 16.0)
        noteTextField.backgroundColor = view.backgroundColor
    }

    private func setupDateField() {
        guard let superView = dateField.superview else {
            return
        }

        dateField.translatesAutoresizingMaskIntoConstraints = false
        dateField.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20).isActive = true
        dateField.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -20).isActive = true
        dateField.topAnchor.constraint(equalTo: superView.topAnchor, constant: 12.0).isActive = true

        dateField.font = UIFont.systemFont(ofSize: 14)
        dateField.textColor = UIColor.systemGray
        dateField.textAlignment = .center

        dateField.isUserInteractionEnabled = false

        dateField.delegate = self
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
        noteTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        saveModel()

        guard let note = data else {
            return
        }

        if isNewNote {
            delegate?.newNote(note: note)
        } else {
            delegate?.updateNote(note: note)
        }
    }

    private func hideKeyboard() {
        titleTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()
    }

    private func showErrorAlert(_ text: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("error", comment: ""),
            message: text,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func saveModel() {
        if data == nil {
            data = Note(title: titleTextField.text ?? String(), text: noteTextField.text, date: currentDate)
        } else {
            data?.title = titleTextField.text ?? String()
            data?.text = noteTextField.text
            data?.date = currentDate
        }
    }

    @objc private func doneButtonTapped(_ sender: Any) {
        saveModel()

        guard !self.isNoteEmpty() else {
            showErrorAlert(NSLocalizedString("emptyNote", comment: ""))
            return
        }

        hideKeyboard()
    }

    @objc private func keyboardWasShowen(_ notification: Notification) {
        navigationItem.rightBarButtonItem = doneButton
        currentDate = Date.now

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
        navigationItem.rightBarButtonItem = nil
        noteTextField.contentInset = UIEdgeInsets.zero
    }
}

extension NoteViewController {
    func isNoteEmpty() -> Bool {
        return data?.isEmpty ?? true
    }
}

extension NoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            noteTextField.becomeFirstResponder()
            noteTextField.selectedTextRange = noteTextField.textRange(
                from: noteTextField.endOfDocument,
                to: noteTextField.endOfDocument
            )
        }
        return true
    }
}
