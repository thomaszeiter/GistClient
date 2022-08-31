//
//  FileListItemCollectionViewCell.swift
//  GistClient
//
//  Created by Tanya Petrenko on 12.08.2022.
//

import UIKit

class FileListItemCollectionViewCell: UICollectionViewCell {

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Private
extension FileListItemCollectionViewCell {

    private func commonInit() {
        addSubviews()
        constraintSubviews()
        configureSubviews()
    }

    private func addSubviews() {
        contentView.addSubview(titleLabel)
    }

    private func constraintSubviews() {
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
    }

    private func configureSubviews() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    }
}

extension FileListItemCollectionViewCell {

    func configure(with file: FileListViewObject) {
        titleLabel.text = file.fileName
    }
}
