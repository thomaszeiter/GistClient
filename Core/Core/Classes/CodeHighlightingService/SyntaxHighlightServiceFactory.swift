//
//  SyntaxHighlightServiceFactory.swift
//  CoreServices
//
//  Created by Tanya Petrenko on 23.08.2022.
//

public class SyntaxHighlightServiceFactory {

    public init() { }

    public func buildSyntaxHighlightService() -> SyntaxHighlightService {
        SyntaxHighlightServiceImpl()
    }
}
