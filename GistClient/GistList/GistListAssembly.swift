//
//  GistListAssembly.swift
//  GistClient
//
//  Created by Tanya Petrenko on 04.08.2022.
//

import Foundation
import UIKit
import DomainServices

final class GistListAssembly {

    private let gistService: GistsService
    private let dateFormatter: DateFormatter
    private let moduleOutput: GistListModuleOutput

    init(gistService: GistsService, dateFormatter: DateFormatter, moduleOutput: GistListModuleOutput) {
        self.gistService = gistService
        self.dateFormatter = dateFormatter
        self.moduleOutput = moduleOutput
    }

    func buildGistListModule() -> UIViewController {
        let viewController = GistListViewController()
        let interactor = GistListInteractor(gistService: gistService)
        let presenter = GistListPresenter(
            viewController: viewController,
            interactor: interactor,
            dateFormatter: dateFormatter,
            moduleOutput: moduleOutput
        )
        viewController.output = presenter
        interactor.output = presenter
        return viewController
    }
}
