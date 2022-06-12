//
//  ListNotesViewController.swift
//  Notes
//
//  Created by Nikita Yakovlev on 09.04.2022.
//

import UIKit

protocol ListNotesDisplayLogic: AnyObject {
    func displayData(_ viewModel: ListNotes.FetchNotes.ViewModel)
    func updateData(_ viewModel: ListNotes.UpdatedNotes.ViewModel)
    func showAlert(_ viewModel: ListNotes.AlertErrors.ViewModel)
}

class ListNotesViewController: UIViewController {
    // MARK: UI vars

    private let plusButton = PlusButton()
    private let rightBarButton = SelectBarButtonItem()
    private let tableView = UITableView()

    // MARK: configure vars

    private let backgroudColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    private let cellIdentifier = "cellNote"

    // MARK: displayedNotes

    private var displayedNotes: [ListNotes.PreviewNote] = []

    // MARK: Interactor, router

    private let interactor: ListNotesBusinesLogic
    let router: (ListNotesRoutingLogic & ListNotesDataPassing)

    // MARK: object lifecycle

    init(interactor: ListNotesBusinesLogic, router: ListNotesRoutingLogic & ListNotesDataPassing) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveNotes),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = NSLocalizedString("listNotes", comment: "")
        plusButton.isHidden = true
        fetchNotes()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        plusButton.showButtonAnimated()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.setEditing(false, animated: false)
    }

    override func viewDidLayoutSubviews() {
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layoutIfNeeded()
    }

    // MARK: Setup views

    private func setupView() {
        self.view.backgroundColor = backgroudColor

        setupTableView()
        setupPlusButton()
        setupRightBarButton()
    }

    private func setupPlusButton() {
        self.view.addSubview(plusButton)

        NSLayoutConstraint.activate([
            plusButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
            plusButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -19.0)
        ])

        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(NoteCellView.self, forCellReuseIdentifier: cellIdentifier)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.backgroundColor = backgroudColor
        tableView.separatorStyle = .none
    }

    private func setupRightBarButton() {
        rightBarButton.target = self
        rightBarButton.action = #selector(rightBarButtonTapped)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    // MARK: User action handlers

    @objc private func plusButtonTapped() {
        switch plusButton.stateButton {
        case .main:
            plusButton.hideButtonAnimated { [weak self] in
                self?.routeToNoteViewController(id: nil)
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
                 interactor.deleteNotes(by: nil)
            }
        }
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

    // MARK: Actions

    private func fetchNotes() {
        interactor.fetchNotes()
    }

    private func deleteNotes(ids: ListNotes.UpdatedNotes.Request) {
        interactor.deleteNotes(by: ids)
    }

    private func routeToNoteViewController(id: Int?) {
        router.routeToNoteDetailsForEditing(at: id)
    }

    @objc func saveNotes() {
        interactor.saveNotes()
    }
}

// MARK: UITableViewDataSource

extension ListNotesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedNotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        guard let customCell = cell as? NoteCellView else {
            return cell
        }

        customCell.setData(displayedNotes[indexPath.row])
        return customCell
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let request = ListNotes.UpdatedNotes.Request(id: indexPath.row)
            deleteNotes(ids: request)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let labelText = NSLocalizedString("labelDelete", comment: "")

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

// MARK: UITableViewDelegate

extension ListNotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            self.routeToNoteViewController(id: indexPath.row)
        }
    }
}

// MARK: ListNotesDisplayLogic

extension ListNotesViewController: ListNotesDisplayLogic {
    func displayData(_ viewModel: ListNotes.FetchNotes.ViewModel) {
        displayedNotes = viewModel.displayedNotes
        tableView.reloadData()
    }

    func updateData(_ viewModel: ListNotes.UpdatedNotes.ViewModel) {
        displayedNotes = viewModel.updatedNotes
    }

    func showAlert(_ viewModel: ListNotes.AlertErrors.ViewModel) {
        AlertManager.showErrorAlert(from: self, text: viewModel.message)
    }
}
