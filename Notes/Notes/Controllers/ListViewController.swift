//
//  ListViewController.swift
//  Notes
//
//  Created by Nikita Yakovlev on 09.04.2022.
//

import UIKit

class ListViewController: UIViewController {
    private let plusButton = PlusButton()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    var arrayNotes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayNotes = NoteArrayDataProvider.getInstance().getSavedNotes() ?? [Note]()

        view.addSubview(scrollView)

        setupStackView()
        setupPlusButton()
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        updateStackContent()

        scrollView.isPagingEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = NSLocalizedString("listNotes", comment: "")
    }
    private func setupPlusButton() {
        self.view.addSubview(plusButton)
        view.backgroundColor = .white
        plusButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60.0).isActive = true
        plusButton.trailingAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
            constant: -19.0
        ).isActive = true

        plusButton.contentVerticalAlignment = .bottom
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        self.view.layoutIfNeeded()
    }

    @objc private func plusButtonTapped() {
        let viewController = NoteViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .currentContext
        self.navigationItem.title = ""
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
                self.navigationItem.title = ""
                destination.delegate = self
                self.navigationController?.pushViewController(destination, animated: true)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layoutIfNeeded()

        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }

    func updateNote(note: Note, index: Int) {
        if index >= arrayNotes.startIndex && index < arrayNotes.endIndex {
            if note.isEmpty {
                arrayNotes.remove(at: index)
            } else {
                arrayNotes[index] = note
            }
        }

        updateStackContent()
    }

    func newNote(note: Note) {
        arrayNotes.append(note)
        updateStackContent()
    }
}
