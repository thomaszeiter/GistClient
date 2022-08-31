//
//  GistListItemCollectionViewCell.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import UIKit
import SnapKit

final class GistListItemCollectionViewCell: UICollectionViewCell {

    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stackView = UIStackView()
    private let filesCountLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.height / 2
    }

    private func commonInit() {
        addSubviews()
        constraintSubviews()
        configureSubviews()
    }

    private func addSubviews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(filesCountLabel)
    }

    private func constraintSubviews() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.top.equalToSuperview().offset(Constants.verticalPadding)
            $0.size.equalTo(Constants.thumbnailSize)
        }
        stackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(Constants.stackViewLeadingOffset)
            $0.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            $0.top.equalToSuperview().offset(Constants.verticalPadding)
            $0.bottom.lessThanOrEqualToSuperview().offset(-Constants.verticalPadding)
        }

        titleLabel.setContentCompressionResistancePriority(.init(rawValue: 754 ), for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.init(rawValue: 753), for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.init(rawValue: 752), for: .vertical)
        filesCountLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .vertical)
    }

    private func configureSubviews() {
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.clipsToBounds = true

        titleLabel.numberOfLines = 3

        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel

        descriptionLabel.numberOfLines = 1
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .secondaryLabel

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = Constants.interItemSpacing

        filesCountLabel.numberOfLines = 1
        filesCountLabel.font = UIFont.systemFont(ofSize: 12)
        filesCountLabel.textColor = .secondaryLabel
    }

    func configure(with gist: GistListItem) {
        titleLabel.attributedText = gist.title
        dateLabel.attributedText = gist.createdAt
        descriptionLabel.attributedText = gist.description
        filesCountLabel.attributedText = gist.numberOfFiles

        dateLabel.isHidden = gist.createdAt == nil
        descriptionLabel.isHidden = gist.description == nil

        thumbnailImageView.setImage(url: gist.userAvatarUrl)
        thumbnailImageView.layoutIfNeeded()
    }

    private enum Constants {
        static let thumbnailSize: CGFloat = 34
        static let stackViewLeadingOffset: CGFloat = 6
        static let interItemSpacing: CGFloat = 4
        static let oneLineTextHeight: CGFloat = 15
        static let verticalPadding: CGFloat = 12
        static let horizontalPadding: CGFloat = 20
        static let secondaryFont: UIFont = UIFont.systemFont(ofSize: 12)
    }
}
