//
//  GistListViewController.swift
//  NNN
//
//  Created by Tanya Petrenko on 31.07.2022.
//

import UIKit
import SnapKit

protocol GistListViewControllerInput: AnyObject {
    func getItems(_ items: [GistListItem])
    func updateItems(_ items: [GistListItem])
    func updateState(_ state: ListDataState)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool)
}

protocol GistListViewControllerOutput: AnyObject {

    func didSelectCell(at indexPath: IndexPath)
    func didScrollAtLastCell()
    func didTapAtTryAgainButton()
    func didPullToRefresh()
    func viewDidLoad()

}

class GistListViewController: UIViewController {

    var presenter: GistListViewControllerOutput?
    private var gists: [GistListItem] = []

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private let globalActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()

    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(globalActivityIndicatorView)
        collectionView.addSubview(refreshControl)

        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        globalActivityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GistListItemCollectionViewCell.self, forCellWithReuseIdentifier: .gistListItemReuseIdentifier)
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: .emptyCellReuseIdentifier)
        collectionView.register(
            RefreshFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RefreshFooterView.headerFooterViewReuseIdentifier)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        view.backgroundColor = .secondarySystemBackground

        title = "Gists List"

        presenter?.viewDidLoad()
    }

    @objc func didPullToRefresh() {
        presenter?.didPullToRefresh()
    }

    private func presentErrorAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Error occurred",
            message: message,
            preferredStyle: .alert)

        let tryAgainAction = UIAlertAction(title: "Try again?", style: .default) { _ in
            self.presenter?.didTapAtTryAgainButton()
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
        var gist = gists[indexPath.item]
        gist.isSeparatorHidden = indexPath.item == gists.count - 1
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: .gistListItemReuseIdentifier,
                for: indexPath) as? GistListItemCollectionViewCell
        else { return EmptyCollectionViewCell() }
        
        cell.configure(with: gist)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:

            return collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: RefreshFooterView.headerFooterViewReuseIdentifier,
                for: indexPath)
        default:
            assert(false, "Unexpected element kind")
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.bounds.size.height)) {
            startFooterRefresh()
            presenter?.didScrollAtLastCell()
        }
    }

    private func startFooterRefresh() {
        guard let footer = collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: IndexPath(row: 0, section: 0)) as? RefreshFooterView else { return }
        footer.startRefresh()
    }

    private func stopFooterRefresh() {
        guard let footer = collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: IndexPath(row: 0, section: 0)) as? RefreshFooterView else { return }
        footer.stopRefresh()
    }

}

extension GistListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gist = gists[indexPath.item]
        return gist.associatedCellType.calculateSelfSize(by: gist, insideBoundsOf: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 24)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectCell(at: indexPath)
    }

}

extension GistListViewController: GistListViewControllerInput {

    func getItems(_ items: [GistListItem]) {
        gists = items
        collectionView.reloadData()
    }

    func updateItems(_ items: [GistListItem]) {
        gists.append(contentsOf: items)
        collectionView.reloadData()
    }

    func updateState(_ state: ListDataState) {
        switch state {
        case .normal:
            globalActivityIndicatorView.isHidden = true
            refreshControl.endRefreshing()
            stopFooterRefresh()
        case .loading:
            globalActivityIndicatorView.isHidden = false
            globalActivityIndicatorView.startAnimating()
        case .error(let message):
            globalActivityIndicatorView.isHidden = true
            refreshControl.endRefreshing()
            stopFooterRefresh()
            presentErrorAlert(message)
        }
    }

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        navigationController?.pushViewController(viewControllerToPresent, animated: flag)
    }
}

extension String {
    static let gistListItemReuseIdentifier = "GistListItemCollectionViewCell"
    static let emptyCellReuseIdentifier = "emptyCellReuseIdentifier"
}

