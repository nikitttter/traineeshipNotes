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
    //  можно не использовать weak, так как в ListViewController нет ссылки на данный класс
    //  и следовательно не возникает проблемы цикла сильных ссылок
    var delegate: ListViewController?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("class NoteViewController has been initialized")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("class NoteViewController has been deallocated")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        dateFormatted.dateFormat = "dd.MM.yyyy EEEE HH:mm"
        setupDoneButton()
        setupHeaderContainer()
        setupNoteField()

        isNewNote = data != nil ? false : true

        titleTextField.text = data?.title
        noteTextField.text = data?.text
        dateField.text = dateFormatted.string(from: currentDate)
     }

    private func setupHeaderContainer() {
        view.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

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

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 20.0),
            titleTextField.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20.0),
            titleTextField.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -70.0),
            titleTextField.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])

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

        NSLayoutConstraint.activate([
            noteTextField.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 16.0),
            noteTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            noteTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            noteTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0)
        ])

        noteTextField.font = UIFont.systemFont(ofSize: 16.0)
        noteTextField.backgroundColor = view.backgroundColor
    }

    private func setupDateField() {
        guard let superView = dateField.superview else {
            return
        }
        dateField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dateField.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20),
            dateField.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -20),
            dateField.topAnchor.constraint(equalTo: superView.topAnchor, constant: 12.0)
        ])

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

        if isNewNote && !note.isEmpty {
            delegate?.newNote(note: note)
        } else if !isNewNote {
            delegate?.updateNote(note: note)
        }
    }

    private func hideKeyboard() {
        titleTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()
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
            AlertManager.showErrorAlert(from: self, text: NSLocalizedString("emptyNote", comment: ""))
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
