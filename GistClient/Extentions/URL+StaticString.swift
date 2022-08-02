//
//  URL+StaticString.swift
//  GistClient
//
//  Created by Tanya Petrenko on 02.08.2022.
//

import Foundation

public extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }

        self = url
    }
}
