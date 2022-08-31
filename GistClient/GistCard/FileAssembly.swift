//
//  FileAssembly.swift
//  GistClient
//
//  Created by Tanya Petrenko on 08.08.2022.
//

import Foundation
import UIKit
import DomainServices
import Core

final class FileAssembly {

    private let gistFilesService: GistFilesService
    private let file: File
    private let syntaxHighlightingService: SyntaxHighlightService

    init(gistFilesService: GistFilesService,
         file: File,
         syntaxHighlightingService: SyntaxHighlightService
    ) {
        self.gistFilesService = gistFilesService
        self.file = file
        self.syntaxHighlightingService = syntaxHighlightingService
    }

    func buildFileModule() -> UIViewController {
        let viewController = FileViewController()
        let interactor = FileInteractor(
            gistFilesService: gistFilesService)
        let presenter = FilePresenter(
            viewController: viewController,
            file: file,
            interactor: interactor,
            syntaxHighlightingService: syntaxHighlightingService
        )
        viewController.output = presenter
        interactor.output = presenter

        return viewController
    }
}
