//
//  NetworkService.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Foundation

class NetworkService {

    private let url = URL(staticString: "https://api.github.com/gists/public")

    func getGists(completion: @escaping (Result<[Gist], Error>) -> Void) {
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: self.url) { (data, _, error) in
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

}