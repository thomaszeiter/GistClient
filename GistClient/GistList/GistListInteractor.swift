//
//  GistListInteractor.swift
//  GistClient
//
//  Created by Tanya Petrenko on 04.08.2022.
//

import Foundation

class GistListInteractor {
    
    private let networkService = NetworkService()
    weak var presenter: GistListInteractorOutput?

    private func loadGists(url: URL, completion: @escaping (Result<[Gist], Error>) -> Void) {
        networkService.getGists(url: url) { result in
            completion(result)
        }
    }
}

extension GistListInteractor: GistListInteractorInput {

    func loadGists(url: URL) {
        loadGists(url: url) { [weak self] result in
            switch result {
            case .success(let gists):
                self?.presenter?.didFinishLoadingGistsWithSuccess(gists)
            case .failure(let error):
                self?.presenter?.didFinishLoadingGistsWithFailure(error)
            }
        }
    }

    func loadNewPageOfGists(url: URL) {
        loadGists(url: url) { [weak self] result in
            switch result {
            case .success(let gists):
                self?.presenter?.didFinishLoadingNewPageOfGistsWithSuccess(gists)
            case .failure(let error):
                self?.presenter?.didFinishLoadingGistsWithFailure(error)
            }
        }
    }
    
}
