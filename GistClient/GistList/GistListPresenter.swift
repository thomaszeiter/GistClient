//
//  GistListPresenter.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Foundation
import UIKit

protocol GistListInput: AnyObject {

    func getGitListItem()
    func didTapGist(_ gist: GistListItem)
    func loadNextPage()

}

class GistListPresenter {

    private let networkService = NetworkService()
    private weak var viewController: GistListViewControllerOutput?
    private var gists: [Gist] = []
    private var currentNumberOfPage = 1

    init(viewController: GistListViewControllerOutput) {
        self.viewController = viewController
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
}

extension GistListPresenter: GistListInput {

    func getGitListItem() {
        viewController?.updateState(.loading)
        networkService.getGists(url: Constants.publicGistsUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let gists):
                self.viewController?.updateState(.normal)
                self.viewController?.getItems(self.makeGistListItems(from: gists))
                self.gists = gists
            case .failure(let error):
                self.viewController?.updateState(.error(message: error.localizedDescription))
            }
        }
    }

    func didTapGist(_ gist: GistListItem) {
        guard let gist = gists.first(where: { $0.id == gist.id }) else { return }
        let gistCardViewController = GistCardViewController()
        let gistCardPresenter = GistCardPresenter(viewController: gistCardViewController, files: gist.files)
        gistCardViewController.presenter = gistCardPresenter
        viewController?.present(gistCardViewController, animated: true)
    }

    func loadNextPage() {
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

        networkService.getGists(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let gists):
                self.viewController?.updateState(.normal)
                self.viewController?.updateItems(self.makeGistListItems(from: gists))
                self.gists = gists
                self.currentNumberOfPage += 1
            case .failure(let error):
                self.viewController?.updateState(.error(message: error.localizedDescription))
            }
        }
    }

}
