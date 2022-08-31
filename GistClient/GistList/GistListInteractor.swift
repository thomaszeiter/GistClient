//
//  GistListInteractor.swift
//  GistClient
//
//  Created by Tanya Petrenko on 04.08.2022.
//

import Foundation
import DomainServices

final class GistListInteractor {

    private let gistService: GistsService

    weak var output: GistListInteractorOutput?

    init(gistService: GistsService) {
        self.gistService = gistService
    }
}

// MARK: - GistListInteractorInput
extension GistListInteractor: GistListInteractorInput {

    func loadGists() {
        gistService.loadGists { [weak self] result in
            switch result {
            case .success(let gists):
                self?.output?.didFinishLoadingGistsWithSuccess(gists)
            case .failure(let error):
                self?.output?.didFinishLoadingGistsWithFailure(error)
            }
        }
    }

    func loadPageOfGists(page: Int) {
        gistService.loadNextPageOfGists(page: page) { [weak self] result in
            switch result {
            case .success(let gists):
                self?.output?.didFinishLoadingNewPageOfGistsWithSuccess(gists)
            case .failure(let error):
                self?.output?.didFinishLoadingGistsWithFailure(error)
            }
        }
    }
}
