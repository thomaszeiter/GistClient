//
//  GistListViewController.swift
//  NNN
//
//  Created by Tanya Petrenko on 31.07.2022.
//

import UIKit
import SnapKit

protocol GistListViewControllerOutput: AnyObject {

    func updateItems(_ items: [GistListItem])
    func updateState(_ state: ListDataState)
}

class GistListViewController: UIViewController {

    private var gists: [GistListItem] = []
    var presenter: GistListInput?

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

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GistListItemCollectionViewCell.self, forCellWithReuseIdentifier: .gistListItemReuseIdentifier)

        view.backgroundColor = .white

        title = "Gists List"

        presenter?.getGitListItem()
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
            self.presenter?.getGitListItem()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alert.addAction(cancelAction)
        alert.addAction(tryAgainAction)
        present(alert, animated: true)

    }

}

extension GistListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        gists.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gist = gists[indexPath.item]
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: .gistListItemReuseIdentifier,
                for: indexPath) as? GistListItemCollectionViewCell
        else { return EmptyCollectionViewCell() }
        
        cell.configure(with: gist)
        return cell
    }

}

extension GistListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let selectedGist = gists[indexPath.item]
        // TODO: openGistCard
    }

}

extension GistListViewController: GistListViewControllerOutput {

    func updateItems(_ items: [GistListItem]) {
        gists = items
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

extension String {
    static let gistListItemReuseIdentifier = "GistListItemCollectionViewCell"
}

