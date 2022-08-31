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

    func didSelectCell(at index: Int)
    func didScrollAtLastCell()
    func didTapAtTryAgainButton()
    func didPullToRefresh()
    func viewDidLoad()
}

final class GistListViewController: UIViewController {

    var output: GistListViewControllerOutput?

    private var gists: [GistListItem] = []

    // MARK: - Subviews
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeLayout())
    private let globalActivityIndicatorView = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        output?.viewDidLoad()
    }

    // MARK: - Actions

    @objc func didPullToRefresh() {
        output?.didPullToRefresh()
    }
}

// MARK: - Setup
extension GistListViewController {

    private func setupUI() {
        addSubviews()
        constraintSubviews()
        configureSubviews()
    }

    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(globalActivityIndicatorView)
        collectionView.addSubview(refreshControl)
    }

    private func constraintSubviews() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        globalActivityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func configureSubviews() {
        configureCollectionView()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.backgroundColor = .secondarySystemBackground

        globalActivityIndicatorView.style = .large
        globalActivityIndicatorView.hidesWhenStopped = true
        globalActivityIndicatorView.isHidden = true

        title = "Discover gists"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(GistListItemCollectionViewCell.self, forCellWithReuseIdentifier: .gistListItemReuseIdentifier)
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: .emptyCellReuseIdentifier)
        collectionView.register(
            RefreshFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RefreshFooterView.headerFooterViewReuseIdentifier)
        collectionView.register(
            EmptyCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: .emptyReusableViewReuseIdentifier)
    }

    private func makeLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

// MARK: - UICollectionViewDataSource
extension GistListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        gists.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: .gistListItemReuseIdentifier,
                for: indexPath
            ) as? GistListItemCollectionViewCell
        else {
            assertionFailure()
            return EmptyCollectionViewCell()
        }

        cell.configure(with: gists[indexPath.item])
        cell.backgroundConfiguration = .listGroupedCell()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            return collectionView.dequeueReusableHeaderView(
                id: RefreshFooterView.headerFooterViewReuseIdentifier,
                for: indexPath
            )
        default:
            assertionFailure()
            return collectionView.dequeueReusableHeaderView(
                id: .emptyReusableViewReuseIdentifier,
                for: indexPath
            )
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let allContentHeight = collectionView.contentSize.height - collectionView.bounds.size.height
        if collectionView.contentOffset.y >= allContentHeight {
            startFooterRefresh()
            output?.didScrollAtLastCell()
        }
    }
}

// MARK: - Refresh
extension GistListViewController {

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

// MARK: - UICollectionViewDelegateFlowLayout
extension GistListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        output?.didSelectCell(at: indexPath.item)
    }
}

// MARK: - GistListViewControllerInput
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
            presentErrorAlert(message) { [weak self] in
                self?.output?.didTapAtTryAgainButton()
            }
        }
    }

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        navigationController?.pushViewController(viewControllerToPresent, animated: flag)
    }
}

extension String {
    static let gistListItemReuseIdentifier = "GistListItemCollectionViewCell"
    static let emptyCellReuseIdentifier = "emptyCellReuseIdentifier"
    static let emptyReusableViewReuseIdentifier = "emptyReusableViewReuseIdentifier"
}
