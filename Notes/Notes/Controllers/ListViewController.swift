//
//  ListViewController.swift
//  Notes
//
//  Created by Nikita Yakovlev on 09.04.2022.
//

import UIKit

class ListViewController: UIViewController {
    private let plusButton = PlusButton()

    var arrayNotes = [Note]()
    private let cellIdentifier = "cellNote"
    private let cellLineSpacing = 4.0
    private let cellHorizontalMargin = 16.0
    private let cellHeight = 90.0

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = cellLineSpacing
        return UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayNotes = NoteArrayDataProvider.getInstance().getSavedNotes() ?? [Note]()

        collectionView.register(NoteCellView.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = cellLineSpacing
            return flowLayout
        }()

        setupCollectionView()
        setupPlusButton()
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = NSLocalizedString("listNotes", comment: "")
        plusButton.isHidden = true
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

    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
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
        collectionView.reloadData()
    }

    func newNote(note: Note) {
        arrayNotes.append(note)
        collectionView.reloadData()
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
}
extension ListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNotes.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)

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
extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.frame.width - cellHorizontalMargin * 2,
            height: cellHeight
        )
    }
}
