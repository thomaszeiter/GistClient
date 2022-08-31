//
//  RefreshFooterView.swift
//  GistClient
//
//  Created by Tanya Petrenko on 03.08.2022.
//

import UIKit
import SnapKit

final class RefreshFooterView: UICollectionReusableView {

    static let headerFooterViewReuseIdentifier = "headerFooterViewReuseIdentifier"

    private let activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        backgroundColor = .white

        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
    }

    func startRefresh() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func stopRefresh() {
        activityIndicator.stopAnimating()
    }
}
