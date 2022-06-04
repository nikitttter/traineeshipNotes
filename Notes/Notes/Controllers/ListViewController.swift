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

    private let tableView = UITableView()

    private var worker: WorkerType = Worker()

    private let backgroudColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("class ListViewController has been initialized")
    }

    deinit {
        print("class ListViewController has been deallocated")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        worker.delegate = self

        arrayNotes = NoteArrayDataProvider.getInstance().getSavedNotes() ?? [Note]()
        worker.fetchData()

        tableView.register(NoteCellView.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelectionDuringEditing = true
        setupTableView()
        setupPlusButton()
        setupRightBarButton()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = NSLocalizedString("listNotes", comment: "")
        plusButton.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        plusButton.showButtonAnimated()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.setEditing(false, animated: false)
    }

    private func setupView() {
        self.view.backgroundColor = backgroudColor
    }

    private func setupPlusButton() {
        self.view.addSubview(plusButton)

        NSLayoutConstraint.activate([
            plusButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
            plusButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -19.0)
        ])

        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.backgroundColor = backgroudColor
        tableView.separatorStyle = .none
    }

    private func setupRightBarButton() {
        rightBarButton.target = self
        rightBarButton.action = #selector(rightBarButtonTapped)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc private func plusButtonTapped() {
        switch plusButton.stateButton {
        case .main:
//            необходим weak, чотюы не создавать цикл сильных ссылок,
//            так как на plusButton есть сильная ссылка в данном классе
            plusButton.hideButtonAnimated { [weak self] in
                self?.routeToNoteViewController(model: nil)
            }
        case .additional:
            if tableView.indexPathsForSelectedRows != nil {
                repeat {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        self.tableView(tableView, commit: .delete, forRowAt: indexPath)
                    }
                } while tableView.indexPathsForSelectedRows != nil
                rightBarButtonTapped()
            } else {
                AlertManager.showErrorAlert(from: self, text: NSLocalizedString("notSelectedNotes", comment: ""))
            }
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

    @objc private func rightBarButtonTapped() {
        switch (tableView.isEditing, rightBarButton.stateButton) {
        case (true, ItemState.main):
            tableView.setEditing(false, animated: false)
        default:
            rightBarButton.stateButton.toggle()
            plusButton.stateButton.toggle()
            tableView.setEditing(!tableView.isEditing, animated: true)
        }
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
        return customCell
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            arrayNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let labelText = NSLocalizedString("labelDelete", comment: "")
//      weak нужен, так как в классе есть ссылка на tableView, и есть риск возникновения цикла сильных ссылок
        let deleteAction = UIContextualAction(style: .normal, title: labelText) { [weak self] _, _, complete in
            self?.tableView(tableView, commit: .delete, forRowAt: indexPath)
            complete(true)
        }

        deleteAction.image = UIImage(named: "RemoveButton")
        deleteAction.backgroundColor = backgroudColor

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            self.routeToNoteViewController(model: arrayNotes[indexPath.row])
        }
    }
}
extension ListViewController: WorkerDelegate {
    func updateInterface(notes: [Note]) {
        arrayNotes.append(contentsOf: notes.compactMap {
            return $0.getOnlineNote()
        })
        self.tableView.reloadData()
    }
}
