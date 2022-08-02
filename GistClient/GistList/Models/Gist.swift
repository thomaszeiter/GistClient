//
//  Gist.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Foundation

struct Gist: Decodable {

    let id: String
    let title: String
    let description: String?
    let files: [String: File]
    let createdAt: String
    let owner: User

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case files
        case createdAt
        case owner
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        files = try container.decode([String: File].self, forKey: .files)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        owner = try container.decode(User.self, forKey: .owner)
        if let title = files.keys.first {
            self.title = title
        } else {
            throw GistError.empty
        }
    }

}

struct File: Decodable {
    let filename: String
    let type: String
    let language: String?
    let rawUrl: URL
    let size: Int
}

struct User: Decodable {
    let login: String
    let avatarUrl: URL
}

enum GistError: Error {
    case empty

    var description: String {
        switch self {
        case .empty:
            return "The gist does not contain any files"
        }
    }
}
