//
//  GistCardAssembly.swift
//  GistClient
//
//  Created by Tanya Petrenko on 12.08.2022.
//

import Foundation
import UIKit
import DomainServices

final class GistCardAssembly {

    private let gistsService: GistsService
    private let gistFilesService: GistFilesService
    private let gistId: String
    private let moduleOutput: GistCardModuleOutput

    init(gistsService: GistsService,
         gistFilesService: GistFilesService,
         gistId: String,
         moduleOutput: GistCardModuleOutput
    ) {
        self.gistsService = gistsService
        self.gistFilesService = gistFilesService
        self.gistId = gistId
        self.moduleOutput = moduleOutput
    }

    func buildGistCardModule() -> UIViewController {
        let viewController = GistCardViewController()
        let interactor = GistCardInteractor(
            gistsService: gistsService,
            gistFilesService: gistFilesService)
        let presenter = GistCardPresenter(
            viewController: viewController,
            interactor: interactor,
            gistId: gistId,
            moduleOutput: moduleOutput
        )
        viewController.output = presenter
        interactor.output = presenter

        return viewController
    }
}
