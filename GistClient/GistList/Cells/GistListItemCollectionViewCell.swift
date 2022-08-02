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

        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
            $0.size.equalTo(34)
        }
        stackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
            $0.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
    }

    func configure(with gist: GistListItem) {
        titleLabel.attributedText = gist.title
        dateLabel.text = gist.createdAt
        descriptionLabel.text = gist.description
        thumbnailImageView.setImage(url: gist.userAvatarUrl)
        thumbnailImageView.layoutIfNeeded()
    }
    
}
