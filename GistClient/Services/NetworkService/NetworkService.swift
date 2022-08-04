//
//  NetworkService.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Foundation

class NetworkService {

    func getGists(url: URL, completion: @escaping (Result<[Gist], Error>) -> Void) {
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(GistError.empty))
                    }
                    return
                }
                do {
                    let gists = try decoder.decode([Gist].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(gists))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
            }
            task.resume()
        }
    }

    func getFileContentRawString(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global().async {

            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                guard
                    let data = data,
                    let rawString = String(data: data, encoding: .ascii)
                else {
                    DispatchQueue.main.async {
                        completion(.failure(GistError.empty))
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(.success(rawString))
                }
            }
            task.resume()

        }
    }

}
