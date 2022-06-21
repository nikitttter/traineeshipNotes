//
//  ViewController.swift
//  Notes
//
//  Created by Nikita Yakovlev on 27.03.2022.
//

import UIKit
import Foundation

protocol NoteDisplayLogic: AnyObject {
    func displayNoteDetails(viewModel: NoteDetails.ShowNoteDetails.ViewModel)
    func showAlert(viewModel: NoteDetails.UpdateNoteModel.ViewModel)
}

class NoteDetailsViewController: UIViewController {
    // MARK: UI vars

    private let titleTextField = UITextField()
    private let doneButton = UIBarButtonItem()
    private let noteTextField = UITextView()
    private let headerContainer = UIView()
    private let dateField = UITextField()

    // MARK: Interactor, router

    private let interactor: NoteBusinesLogic
    let router: NoteRoutingLogic & NoteDataPassing

    // MARK: Object lifecycle

    init(interactor: NoteBusinesLogic, router: NoteRoutingLogic & NoteDataPassing) {
        self.interactor = interactor
        self.router = router

        super.init(nibName: nil, bundle: nil)
        print("class NoteViewController has been initialized")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("class NoteViewController has been deallocated")
    }

    // MARK: ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        setupDoneButton()
        setupHeaderContainer()
        setupNoteField()
        getNoteDetail()
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

        saveNote()
    }

    // MARK: setup views

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

    // MARK: User action handlers

    @objc private func doneButtonTapped(_ sender: Any) {
        updateNoteDetail()
        hideKeyboard()
    }

    // MARK: Work with keyboard

    private func hideKeyboard() {
        titleTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()
    }

    @objc private func keyboardWasShowen(_ notification: Notification) {
        navigationItem.rightBarButtonItem = doneButton

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

    // MARK: Actions

    private func getNoteDetail() {
        interactor.provideNoteDetail()
    }

    private func updateNoteDetail() {
        let request = NoteDetails.UpdateNoteModel.Request(
            noteHeader: titleTextField.text,
            noteText: noteTextField.text
        )
        interactor.updateNoteDetail(request: request)
    }

    private func saveNote() {
        let request = NoteDetails.SaveNoteModel.Request(
            noteHeader: titleTextField.text,
            noteText: noteTextField.text
        )
        interactor.saveNote(request: request)
        router.routeToNotesList()
    }
}

// MARK: UITextFieldDelegate

extension NoteDetailsViewController: UITextFieldDelegate {
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

// MARK: NoteDisplayLogic

extension NoteDetailsViewController: NoteDisplayLogic {
    func displayNoteDetails(viewModel: NoteDetails.ShowNoteDetails.ViewModel) {
        titleTextField.text = viewModel.noteHeader
        noteTextField.text = viewModel.noteText
        dateField.text = viewModel.noteDate
    }

    func showAlert(viewModel: NoteDetails.UpdateNoteModel.ViewModel) {
        AlertManager.showErrorAlert(from: self, text: viewModel.message)
    }
}
