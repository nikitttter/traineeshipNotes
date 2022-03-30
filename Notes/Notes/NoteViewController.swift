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

    private let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        setupHeaderContainer()
        setupTitleField()
        setupDoneButton()
        setupNoteField()

        titleTextField.text = defaults.value(forKey: "title") as? String
        noteTextField.text = defaults.value(forKey: "note") as? String
    }

    private func setupHeaderContainer() {
        view.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false

        headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        headerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        headerContainer.addSubview(titleTextField)
    }

    private func setupTitleField() {
        guard let superView = titleTextField.superview else {
            return
        }
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20).isActive = true
        titleTextField.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
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

    override func viewDidLayoutSubviews() {
        noteTextField.layer.masksToBounds = true
        noteTextField.layer.cornerRadius = noteTextField.smallerSide / 30
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

    @objc private func doneButtonTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()

        defaults.set(titleTextField.text, forKey: "title")
        defaults.set(noteTextField.text, forKey: "note")
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
}

extension UITextView {
    var smallerSide: CGFloat {
        return self.frame.width < self.frame.height ? self.frame.width : self.frame.height
    }
}
