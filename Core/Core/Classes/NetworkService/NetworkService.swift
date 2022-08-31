//
//  NetworkService.swift
//  GistClient
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Alamofire

public protocol NetworkService {

    func load<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
    func loadString(url: URL, completion: @escaping (Result<String, Error>) -> Void)
}

final class NetworkServiceImpl { }

extension NetworkServiceImpl: NetworkService {

    func load<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url).response { response in
            if let error = response.error {
                completion(.failure(error))
            }
            guard let data = response.data else {
                completion(.failure(NetworkServiceError.empty))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601

                let contents = try decoder.decode(T.self, from: data)

                completion(.success(contents))
            } catch {
                completion(.failure(error))
                return
            }
        }
    }

    func loadString(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        AF.request(url).response { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }

            guard
                let data = response.data,
                let rawString = String(data: data, encoding: .ascii)
            else {
                completion(.failure(NetworkServiceError.empty))
                return
            }

            completion(.success(rawString))
        }
    }
}
