//
//  GistFilesService.swift
//  GistClient
//
//  Created by Tanya Petrenko on 04.08.2022.
//

import Core

public protocol GistFilesService {

    func loadGistFile(url: URL, completion: @escaping (Result<String, Error>) -> Void)
}

final class GistFilesServiceImpl {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension GistFilesServiceImpl: GistFilesService {

    func loadGistFile(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        networkService.loadString(url: url, completion: completion)
    }
}
