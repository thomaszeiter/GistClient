//
//  GistCardInteractor.swift
//  GistClient
//
//  Created by Tanya Petrenko on 12.08.2022.
//

import Foundation
import DomainServices

class GistCardInteractor {

    weak var output: GistCardInteractorOutput?
    private let gistsService: GistsService
    private let gistFilesService: GistFilesService

    init(gistsService: GistsService, gistFilesService: GistFilesService) {
        self.gistsService = gistsService
        self.gistFilesService = gistFilesService
    }
}

extension GistCardInteractor: GistCardInteractorInput {

    func loadGist(by id: String) {
        gistsService.loadGist(id: id) { [weak self] result in
            switch result {
            case .success(let gist):
                self?.output?.didGistLoadWithSuccess(gist)
            case .failure(let error):
                self?.output?.didGistLoadWithFailure(error)
            }
        }
    }
}
