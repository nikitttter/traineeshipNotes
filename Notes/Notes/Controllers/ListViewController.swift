//
//  ListViewController.swift
//  Notes
//
//  Created by Nikita Yakovlev on 09.04.2022.
//

import UIKit

class ListViewController: UIViewController {
    private let plusButton = PlusButton()
    private let rightBarButton = SelectBarButtonItem()

    var arrayNotes = [Note]()
    private let cellIdentifier = "cellNote"
    private let cellLineSpacing = 4.0
    private let cellHorizontalMargin = 16.0

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayNotes = NoteArrayDataProvider.getInstance().getSavedNotes() ?? [Note]()

        tableView.register(NoteCellView.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        setupTableView()
        setupPlusButton()
        setupRightBarButton()
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = NSLocalizedString("listNotes", comment: "")
        plusButton.isHidden = true
        tableView.setEditing(false, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        showButtonAnimated()
    }

    private func setupPlusButton() {
        self.view.addSubview(plusButton)
        view.backgroundColor = .white
        plusButton.bottomAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
            constant: -20.0
        ).isActive = true
        plusButton.trailingAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
            constant: -19.0
        ).isActive = true

        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -16
        ).isActive = true
        tableView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 16
        ).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        tableView.separatorStyle =  .none
        tableView.separatorColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    }

    private func setupRightBarButton() {
        rightBarButton.target = self
        rightBarButton.action = #selector(rightBarButtonTapped)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    @objc private func plusButtonTapped() {
        hideButtonAnimated { [weak self] in
            self?.routeToNoteViewController(model: nil)
        }
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
    }

    func updateNote(note: Note) {
        if let index = arrayNotes.firstIndex(where: { $0.id == note.id }) {
            if note.isEmpty {
                arrayNotes.remove(at: index)
            } else {
                arrayNotes[index] = note
            }
        }
        tableView.reloadData()
    }

    func newNote(note: Note) {
        arrayNotes.append(note)
        tableView.reloadData()
    }

    private func showButtonAnimated() {
        let initialButtonY = self.plusButton.frame.minY
        plusButton.frame.origin.y = UIScreen.main.bounds.maxY
        plusButton.isHidden = false

        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.9,
            options: [],
            animations: { [weak self] in
                self?.plusButton.frame.origin.y = initialButtonY
            },
            completion: nil
        )
    }

    private func hideButtonAnimated(completion: (() -> Void)?) {
        let initialButtonY = self.plusButton.frame.minY

        UIView.animateKeyframes(
            withDuration: 1.5,
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.6,
                    animations: { [weak self] in
                        self?.plusButton.frame.origin.y = initialButtonY - 20
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.6,
                    relativeDuration: 0.4,
                    animations: { [weak self] in
                        self?.plusButton.frame.origin.y = UIScreen.main.bounds.maxY
                    }
                )
            },
            completion: { [weak plusButton] _ in
                plusButton?.isHidden = true
                plusButton?.frame.origin.y = initialButtonY
                completion?()
            }
        )
    }

   @objc private func rightBarButtonTapped() {
       rightBarButton.stateButton.toggle()
       plusButton.stateButton.toggle()
       switch rightBarButton.stateButton {
       case .main:
           tableView.setEditing(false, animated: true)
       case .additional:
           tableView.setEditing(true, animated: true)
       }

       print(#function)
    }
}
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        guard let customCell = cell as? NoteCellView else {
            return cell
        }

        customCell.setData(arrayNotes[indexPath.row])
        customCell.closure = { [weak self] model in
            self?.routeToNoteViewController(model: model)
        }

        return customCell
    }
}
