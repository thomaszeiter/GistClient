//
//  FilesListViewController.swift
//  GistClient
//
//  Created by Tanya Petrenko on 12.08.2022.
//

import UIKit
import SnapKit

protocol FilesListViewControllerOutput: AnyObject {

    func viewDidLoad()
    func didSelectCell(at index: Int)
}

protocol FilesListViewControllerInput: AnyObject {

    func updateFiles(_ files: [FileListViewObject])
}

class FilesListViewController: UIViewController {

    var output: FilesListViewControllerOutput?
    private var files: [FileListViewObject] = []

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        output?.viewDidLoad()
    }
}

// MARK: - Setup
extension FilesListViewController {

    private func setup() {
        addSubviews()
        constraintSubviews()
        setupSubviews()
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func addSubviews() {
        view.addSubview(collectionView)
    }

    private func constraintSubviews() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FileListItemCollectionViewCell.self, forCellWithReuseIdentifier: .fileListItemReuseIdentifier)
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: .emptyCellReuseIdentifier)
        view.backgroundColor = .white

        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
    }

    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

// MARK: - GistCardViewControllerInput
extension FilesListViewController: FilesListViewControllerInput {

    func updateFiles(_ files: [FileListViewObject]) {
        self.files = files
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension FilesListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        files.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let file = files[indexPath.item]
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: .fileListItemReuseIdentifier,
                for: indexPath) as? FileListItemCollectionViewCell
        else { return EmptyCollectionViewCell() }

        cell.configure(with: file)
        cell.backgroundConfiguration = .listGroupedCell()

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FilesListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        output?.didSelectCell(at: indexPath.item)
    }
}

extension String {
    static let fileListItemReuseIdentifier = "fileListItemReuseIdentifier"
}
