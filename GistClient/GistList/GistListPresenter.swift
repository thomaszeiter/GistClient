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

}

class GistListPresenter {

    private let networkService = NetworkService()
    private weak var viewController: GistListViewControllerOutput?
    private var gists: [Gist] = []

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
            let mutableAttrString = NSMutableAttributedString(attributedString: ownerName)
            mutableAttrString.append(separator)
            mutableAttrString.append(gistName)

            let date = dateFormatter.date(from: gist.createdAt) ?? Date()
            let dateFormattedString = dateFormatter.string(from: date)
            let dateString = "Created " + dateFormattedString

            return GistListItem(
                id: gist.id,
                userAvatarUrl: gist.owner.avatarUrl,
                title: mutableAttrString,
                createdAt: dateString,
                description: gist.description)
        }
    }
}

extension GistListPresenter: GistListInput {

    func getGitListItem() {
        viewController?.updateState(.loading)
        networkService.getGists { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let gists):
                self.viewController?.updateState(.normal)
                self.viewController?.updateItems(self.makeGistListItems(from: gists))
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

}
