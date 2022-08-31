//
//  GistsService.swift
//  GistClient
//
//  Created by Tanya Petrenko on 04.08.2022.
//

import Core

public protocol GistsService {

    func loadGists(completion: @escaping (Result<[Gist], Error>) -> Void)
    func loadNextPageOfGists(page: Int, completion: @escaping (Result<[Gist], Error>) -> Void)
    func loadGist(id: String, completion: @escaping (Result<Gist, Error>) -> Void)
}

final class GistsServiceImpl {

    private let networkService: NetworkService
    private let publicGistsUrl = URL(staticString: "https://api.github.com/gists/public")

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension GistsServiceImpl: GistsService {

    func loadGists(completion: @escaping (Result<[Gist], Error>) -> Void) {
        networkService.load(url: publicGistsUrl, completion: completion)
    }

    func loadNextPageOfGists(page: Int, completion: @escaping (Result<[Gist], Error>) -> Void) {
        guard let url = composeURL(pageNumber: page) else {
            completion(.failure(GistError.empty))
            return
        }
        networkService.load(url: url, completion: completion)
    }

    func loadGist(id: String, completion: @escaping (Result<Gist, Error>) -> Void) {
        guard let url = composeURL(gistId: id) else {
            completion(.failure(GistError.empty))
            return
        }
        networkService.load(url: url, completion: completion)
    }
}

// MARK: Private methods

extension GistsServiceImpl {

    private func composeURL(pageNumber: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = "/gists/public"
        let pageQueryItem = URLQueryItem(name: "page", value: pageNumber.description)
        urlComponents.queryItems = [pageQueryItem]
        return urlComponents.url
    }

    private func composeURL(gistId: String) -> URL? {
        let urlString = "https://api.github.com/gists/" + gistId
        return URL(string: urlString)
    }
}
