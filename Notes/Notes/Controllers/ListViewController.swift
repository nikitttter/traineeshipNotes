//
//  ListViewController.swift
//  Notes
//
//  Created by Nikita Yakovlev on 09.04.2022.
//

import UIKit
protocol ListViewControllerDelegate: AnyObject {
    func updateNote(note: Note, index: Int)
    func newNote(note: Note)
}

class ListViewController: UIViewController {
    private let plusButton = PlusButton()
    private let stackView = UIStackView()
    var arrayNotes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        arrayNotes.append(Note(title: "title1", text: "ivjvhu", date: Date.now))
//        arrayNotes.append(Note(title: "title2", text: "vvrvbb", date: Date.now))
//        arrayNotes.append(Note(title: "title3", text: "ivbtyjujvhu", date: Date.now))

        self.navigationItem.title = "Notes"
        setupPlusButton()
        setupStackView()
        self.view.backgroundColor = .lightGray
        updateStackContent()
    }

    private func setupPlusButton() {
        self.view.addSubview(plusButton)
        view.backgroundColor = .white
        plusButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60.0).isActive = true
        plusButton.trailingAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
            constant: -19.0
        ).isActive = true
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    private func setupStackView() {
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.topAnchor,
            constant: 26.0
        ).isActive = true
        stackView.leadingAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
            constant: 16.0
        ).isActive = true
        stackView.trailingAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
            constant: -16.0
        ).isActive = true

        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.distribution = .fill
    }

    func updateStackContent() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for note in arrayNotes {
            let viewNote = NoteCellView()
            viewNote.dateField.setText(date: note.date, format: "dd.MM.yyyy")
            viewNote.textField.text = note.text
            viewNote.titleField.text = note.title
            stackView.addArrangedSubview(viewNote)
            viewNote.addTarget(self, action: #selector(noteCellTapped(_ :)), for: .touchUpInside)
        }
    }

    @objc private func plusButtonTapped() {
        let viewController = NoteViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .currentContext
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func noteCellTapped(_ sender: Any) {
        if let noteCellView = sender as? NoteCellView {
            if let index = stackView.arrangedSubviews.firstIndex(of: noteCellView) {
                let destination = NoteViewController()
                destination.closure = { [weak self] in
                    if let note = self?.arrayNotes[index] {
                        return (index, note)
                    }
                    return nil
                }
                destination.delegate = self
                self.navigationController?.pushViewController(destination, animated: true)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layoutIfNeeded()
    }

    func updateNote(note: Note, index: Int) {
        if index >= arrayNotes.startIndex && index < arrayNotes.endIndex {
            arrayNotes[index] = note
        }

        updateStackContent()
    }

    func newNote(note: Note) {
        arrayNotes.append(note)
        updateStackContent()
    }
}
