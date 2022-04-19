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
            viewNote.setData(note)
            viewNote.closure = { [weak self] model in
                self?.routeToNoteViewController(model: model)
            }
            stackView.addArrangedSubview(viewNote)
        }
        self.view.layoutIfNeeded()
    }

    @objc private func plusButtonTapped() {
        routeToNoteViewController(model: nil)
    }

    private func routeToNoteViewController(model: Note?) {
        let destination = NoteViewController()
        if let model = model {
            destination.data = model
        }
        destination.delegate = self
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(destination, animated: true)
    }

    override func viewDidLayoutSubviews() {
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layoutIfNeeded()

        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }

    func updateNote(note: Note) {
        if let index = arrayNotes.firstIndex(where: { $0.id == note.id }) {
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
