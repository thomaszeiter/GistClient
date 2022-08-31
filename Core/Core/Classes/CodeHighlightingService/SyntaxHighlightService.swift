//
//  SyntaxHighlightService.swift
//  GistClient
//
//  Created by Tanya Petrenko on 09.08.2022.
//

import UIKit
import Highlightr

public protocol SyntaxHighlightService {

    func highlightSyntax(code: String, language: String?, completion: @escaping (NSAttributedString) -> Void)
}

final class SyntaxHighlightServiceImpl: SyntaxHighlightService {

    private let highlightr = Highlightr()

    func highlightSyntax(code: String, language: String?, completion: @escaping (NSAttributedString) -> Void) {
        let unformattedString = NSAttributedString(
            string: code,
            attributes: [.font: UIFont.systemFont(ofSize: 14)]
        )
        highlightr?.setTheme(to: "github")

        DispatchQueue.global().async {
            let highlightedCode = self.highlightr?.highlight(code, as: language, fastRender: true) ?? unformattedString
            DispatchQueue.main.async {
                let result = highlightedCode.string == "undefined"
                ? unformattedString
                : highlightedCode
                completion(result)
            }
        }
    }
}
