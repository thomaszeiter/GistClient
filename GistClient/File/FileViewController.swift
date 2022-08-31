//
//  FileViewController.swift
//  GistClient
//
//  Created by Tanya Petrenko on 02.08.2022.
//

import UIKit
import SnapKit

protocol FileViewControllerInput: AnyObject {

    func updateItems(_ items: [FileViewObject])
    func updateState(_ state: ListDataState)
}

protocol FileViewControllerOutput: AnyObject {

    func viewDidLoad()
    func didTapAtTryAgainButton()
}

final class FileViewController: UIViewController {

    var output: FileViewControllerOutput?
    private var files: [FileViewObject] = []

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    private let activityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        output?.viewDidLoad()
    }
}

// MARK: - Setup
extension FileViewController {

    private func setup() {
        addSubviews()
        constraintSubviews()
        setupSubviews()
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
    }

    private func constraintSubviews() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupSubviews() {
        collectionView.dataSource = self
        collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: .fileItemReuseIdentifier)
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: .emptyCellReuseIdentifier)
        view.backgroundColor = .white

        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = false

        activityIndicatorView.tintColor = .blue
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isHidden = true
    }

    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

// MARK: - FileViewControllerInput
extension FileViewController: FileViewControllerInput {

    func updateItems(_ items: [FileViewObject]) {
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
            presentErrorAlert(message) { [weak self] in
                self?.output?.didTapAtTryAgainButton()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FileViewController: UICollectionViewDataSource {

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
        cell.backgroundConfiguration = .listGroupedCell()
        
        return cell
    }
}

extension String {
    static let fileItemReuseIdentifier = "FileCollectionViewCell"
}
