//
//  GistListPresenter.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Foundation
import UIKit
import DomainServices

protocol GistListModuleOutput: AnyObject {

    func didOpenGist(by id: String)
}

protocol GistListInteractorOutput: AnyObject {

    func didFinishLoadingGistsWithSuccess(_ gists: [Gist])
    func didFinishLoadingNewPageOfGistsWithSuccess(_ gists: [Gist])
    func didFinishLoadingGistsWithFailure(_ error: Error)
}

protocol GistListInteractorInput: AnyObject {

    func loadGists()
    func loadPageOfGists(page: Int)
}

final class GistListPresenter {

    private let interactor: GistListInteractorInput
    private weak var viewController: GistListViewControllerInput?
    private let dateFormatter: DateFormatter
    private weak var moduleOutput: GistListModuleOutput?

    // MARK: - Module state
    private var gists: [Gist] = []
    private var currentNumberOfPage = 1
    private var isPageRefreshing = false

    init(viewController: GistListViewControllerInput,
         interactor: GistListInteractorInput,
         dateFormatter: DateFormatter,
         moduleOutput: GistListModuleOutput?
    ) {
        self.viewController = viewController
        self.interactor = interactor
        self.dateFormatter = dateFormatter
        self.moduleOutput = moduleOutput
    }
}

// MARK: - Private
extension GistListPresenter {

    private func makeGistListItems(from gists: [Gist]) -> [GistListItem] {
        gists.enumerated().map { _, gist in
            let ownerName = NSAttributedString(
                string: gist.owner.login + " / ",
                attributes: [.font: UIFont.systemFont(ofSize: 14)])
            let gistName = NSAttributedString(
                string: gist.title,
                attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
            let mutableAttributedString = NSMutableAttributedString(attributedString: ownerName)
            mutableAttributedString.append(gistName)

            let dateString: NSAttributedString?
            if let date = gist.createdAt {
                let dateFormattedString = dateFormatter.string(from: date)
                dateString = NSAttributedString(
                    string: "Created " + dateFormattedString,
                    attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.secondaryLabel]
                )
            } else {
                dateString = nil
            }

            let description: NSAttributedString?
            if let descriptionString = gist.description {
                description = NSAttributedString(
                    string: descriptionString,
                    attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.secondaryLabel]
                )
            } else {
                description = nil
            }

            let numberOfFiles = NSAttributedString(
                string: "Files count: \(gist.files.count)",
                attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.secondaryLabel]
            )

            return GistListItem(
                id: gist.id,
                userAvatarUrl: gist.owner.avatarUrl,
                title: mutableAttributedString,
                createdAt: dateString,
                description: description,
                numberOfFiles: numberOfFiles
            )
        }
    }

    private func getGitListItems() {
        viewController?.updateState(.loading)
        interactor.loadGists()
    }

    private func loadNextPage() {
        let page = currentNumberOfPage + 1
        interactor.loadPageOfGists(page: page)
    }

    private func openGist(_ id: String) {
        moduleOutput?.didOpenGist(by: id)
    }
}

// MARK: - GistListViewControllerOutput
extension GistListPresenter: GistListViewControllerOutput {

    func didScrollAtLastCell() {
        if !isPageRefreshing {
            isPageRefreshing = true
            loadNextPage()
        }
    }

    func didTapAtTryAgainButton() {
        getGitListItems()
    }

    func didPullToRefresh() {
        interactor.loadGists()
    }

    func viewDidLoad() {
        getGitListItems()
    }

    func didSelectCell(at index: Int) {
        let gistId = gists[index].id
        openGist(gistId)
    }
}

// MARK: - GistListInteractorOutput
extension GistListPresenter: GistListInteractorOutput {

    func didFinishLoadingGistsWithSuccess(_ gists: [Gist]) {
        viewController?.updateState(.normal)
        viewController?.getItems(self.makeGistListItems(from: gists))
        self.gists = gists
    }

    func didFinishLoadingNewPageOfGistsWithSuccess(_ gists: [Gist]) {
        viewController?.updateState(.normal)
        viewController?.updateItems(self.makeGistListItems(from: gists))
        self.gists.append(contentsOf: gists)
        currentNumberOfPage += 1
        isPageRefreshing = false
    }

    func didFinishLoadingGistsWithFailure(_ error: Error) {
        viewController?.updateState(.error(message: error.localizedDescription))
    }
}
