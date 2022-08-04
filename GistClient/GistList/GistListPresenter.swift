//
//  GistListPresenter.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Foundation
import UIKit

protocol GistListInteractorOutput: AnyObject {

    func didFinishLoadingGistsWithSuccess(_ gists: [Gist])
    func didFinishLoadingNewPageOfGistsWithSuccess(_ gists: [Gist])
    func didFinishLoadingGistsWithFailure(_ error: Error)

}

protocol GistListInteractorInput: AnyObject {

    func loadGists(url: URL)
    func loadNewPageOfGists(url: URL)
    
}

class GistListPresenter {

    private let interactor: GistListInteractorInput
    private weak var viewController: GistListViewControllerInput?
    private var gists: [Gist] = []
    private var currentNumberOfPage = 1
    private var isPageRefreshing = false

    init(viewController: GistListViewControllerInput,
         interactor: GistListInteractorInput) {
        self.viewController = viewController
        self.interactor = interactor
    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yy"
        return dateFormatter
    }()

    private func makeGistListItems(from gists: [Gist]) -> [GistListItem] {
        gists.map { gist in
            let ownerName = NSAttributedString(
                string: gist.owner.login,
                attributes: [.font: UIFont.systemFont(ofSize: 14)])
            let separator = NSAttributedString(
                string: " / ",
                attributes: [.font: UIFont.systemFont(ofSize: 14)])
            let gistName = NSAttributedString(
                string: gist.title,
                attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
            let mutableAttributedString = NSMutableAttributedString(attributedString: ownerName)
            mutableAttributedString.append(separator)
            mutableAttributedString.append(gistName)

            let date = dateFormatter.date(from: gist.createdAt) ?? Date()
            let dateFormattedString = dateFormatter.string(from: date)
            let dateString = "Created " + dateFormattedString

            return GistListItem(
                id: gist.id,
                userAvatarUrl: gist.owner.avatarUrl,
                title: mutableAttributedString,
                createdAt: dateString,
                description: gist.description)
        }
    }

    private func getGitListItems() {
        viewController?.updateState(.loading)
        interactor.loadGists(url: Constants.publicGistsUrl)
    }

    private func loadNextPage() {
        let newPage = currentNumberOfPage + 1
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = "/gists/public"
        let pageQueryItem = URLQueryItem(name: "page", value: newPage.description)
        urlComponents.queryItems = [pageQueryItem]

        guard let url = urlComponents.url else {
            viewController?.updateState(.error(message: "Wrong request"))
            return
        }
        interactor.loadNewPageOfGists(url: url)
    }

    private func openGist(_ gist: Gist) {
        let gistCardViewController = GistCardViewController()
        let gistCardPresenter = GistCardPresenter(viewController: gistCardViewController, files: gist.files)
        gistCardViewController.presenter = gistCardPresenter
        viewController?.present(gistCardViewController, animated: true)
    }

}

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
        getGitListItems()
    }

    func viewDidLoad() {
        getGitListItems()
    }

    func didSelectCell(at indexPath: IndexPath) {
        let gist = gists[indexPath.item]
        openGist(gist)
    }

}

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
