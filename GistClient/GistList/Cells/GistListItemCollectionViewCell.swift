//
//  GistListItemCollectionViewCell.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import UIKit
import SnapKit

class GistListItemCollectionViewCell: UICollectionViewCell {

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 4
        return stackView
    }()

    private let separator = UIView()

    override var reuseIdentifier: String? {
        .gistListItemReuseIdentifier
    }
    
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
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionLabel)
        contentView.addSubview(separator)

        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(12)
            $0.size.equalTo(Constants.thumbnailSize)
        }
        stackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(Constants.stackViewLeadingOffset)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1 / UIScreen.main.nativeScale)
        }
        separator.backgroundColor = .separator
    }

    func configure(with gist: GistListItem) {
        titleLabel.attributedText = gist.title
        dateLabel.text = gist.createdAt
        descriptionLabel.text = gist.description
        thumbnailImageView.setImage(url: gist.userAvatarUrl)
        thumbnailImageView.layoutIfNeeded()
        separator.isHidden = gist.isSeparatorHidden
    }

    private enum Constants {
        static let thumbnailSize: CGFloat = 34
        static let stackViewLeadingOffset: CGFloat = 6
    }
    
}

extension GistListItemCollectionViewCell {

    static func calculateSelfSize(by content: GistListItem, insideBoundsOf collectionView: UICollectionView) -> CGSize {
        let titleHeight = content.title.boundingRect(
            with: CGSize(
                width: collectionView.bounds.size.width - 40 - Constants.thumbnailSize - Constants.stackViewLeadingOffset,
                height: .greatestFiniteMagnitude),
            options: [],
            context: nil)
            .height
        
        let dateHeight: CGFloat = 15

        if let content = content.description, !content.isEmpty {
            let descriptionHeight: CGFloat = 15
            let height = titleHeight + 4 + dateHeight + 4 + descriptionHeight + 24
            return CGSize(width: collectionView.bounds.width, height: height)
        } else {
            let height = titleHeight + 4 + dateHeight + 24
            return CGSize(width: collectionView.bounds.width, height: height)
        }
    }

}
