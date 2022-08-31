//
//  Gist.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Foundation

public struct Gist: Decodable {

    public let id: String
    public let title: String
    public let description: String?
    public let files: [String: File]
    public let createdAt: Date?
    public let owner: User

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case files
        case createdAt
        case owner
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        files = try container.decode([String: File].self, forKey: .files)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        owner = try container.decode(User.self, forKey: .owner)
        if let title = files.keys.first {
            self.title = title
        } else {
            throw GistError.empty
        }
    }

}

public struct File: Decodable {

    public let filename: String
    public let type: String
    public let language: String?
    public let rawUrl: URL
    public let size: Int
}

public struct User: Decodable {
    public let login: String
    public let avatarUrl: URL
}

public enum GistError: Error {
    case empty
}
