//
//  GistCardViewController.swift
//  GistClient
//
//  Created by Tanya Petrenko on 12.08.2022.
//

import Core
import UIKit
import SnapKit

protocol GistCardViewControllerInput: AnyObject {

    func updateState(_ state: ListDataState)
    func filesModuleEmbedSettings() -> TargetModuleEmbedSettings
}

protocol GistCardViewControllerOutput: AnyObject {

    func viewDidLoad()
    func didTapAtTryAgainButton()
}

class GistCardViewController: UIViewController {

    var output: GistCardViewControllerOutput?

    private let activityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        output?.viewDidLoad()
    }
}

// MARK: - Setup
extension GistCardViewController {
    private func setup() {
        addSubviews()
        constraintSubviews()
        setupSubviews()
    }

    private func addSubviews() {
        view.addSubview(activityIndicatorView)
    }

    private func constraintSubviews() {
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupSubviews() {
        view.backgroundColor = .white

        activityIndicatorView.tintColor = .blue
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isHidden = true
    }
}

// MARK: - GistCardViewControllerInput
extension GistCardViewController: GistCardViewControllerInput {

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

    func filesModuleEmbedSettings() -> TargetModuleEmbedSettings {
        TargetModuleEmbedSettings(containerView: view, viewController: self)
    }
}
