//
//  FileCollectionViewCell.swift
//  GistClient
//
//  Created by Tanya Petrenko on 02.08.2022.
//

import UIKit
import SnapKit

final class FileCollectionViewCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let stackView = UIStackView()

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
extension FileCollectionViewCell {

    private func commonInit() {
        addSubviews()
        constraintSubviews()
        configureSubviews()
    }

    private func addSubviews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
    }

    private func constraintSubviews() {
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
    }

    private func configureSubviews() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)

        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 12
    }
}

extension FileCollectionViewCell {

    func configure(with file: FileViewObject) {
        titleLabel.text = file.filename
        contentLabel.attributedText = file.content
    }
}
