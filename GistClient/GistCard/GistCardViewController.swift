//
//  GistCardViewController.swift
//  GistClient
//
//  Created by Tanya Petrenko on 02.08.2022.
//

import UIKit
import SnapKit

protocol GistCardViewControllerOutput: AnyObject {

    func updateItems(_ items: [FileListItem])
    func updateState(_ state: ListDataState)

}

class GistCardViewController: UIViewController {

    private var files: [FileListItem] = []
    var presenter: GistCardInput?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.tintColor = .blue
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        collectionView.dataSource = self
        collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: .fileItemReuseIdentifier)
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: .emptyCellReuseIdentifier)
        view.backgroundColor = .white

        presenter?.getFiles()
    }

    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }

    private func presentErrorAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Error occurred",
            message: message,
            preferredStyle: .alert)

        let tryAgainAction = UIAlertAction(title: "Try again?", style: .default) { _ in
            self.presenter?.getFiles()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alert.addAction(cancelAction)
        alert.addAction(tryAgainAction)
        present(alert, animated: true)

    }

}

extension GistCardViewController: GistCardViewControllerOutput {

    func updateItems(_ items: [FileListItem]) {
        files = items
        collectionView.reloadData()
    }

    func updateState(_ state: ListDataState) {
        switch state {
        case .normal:
            activityIndicatorView.isHidden = true
        case .loading:
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        case .error(let message):
            activityIndicatorView.isHidden = true
            presentErrorAlert(message)
        }
    }

}

extension GistCardViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        files.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let file = files[indexPath.item]
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: .fileItemReuseIdentifier,
                for: indexPath) as? FileCollectionViewCell
        else { return EmptyCollectionViewCell() }

        cell.configure(with: file)
        return cell
    }

}

extension String {
    static let fileItemReuseIdentifier = "FileCollectionViewCell"
}
