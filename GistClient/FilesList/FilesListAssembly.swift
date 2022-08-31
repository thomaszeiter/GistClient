//
//  FilesListAssembly.swift
//  GistClient
//
//  Created by Tanya Petrenko on 12.08.2022.
//

import UIKit
import DomainServices

class FilesListAssembly {

    private let files: [File]
    private let moduleOutput: FilesListModuleOutput

    init(files: [File], moduleOutput: FilesListModuleOutput) {
        self.files = files
        self.moduleOutput = moduleOutput
    }

    func buildFilesListModule() -> UIViewController {
        let viewController = FilesListViewController()
        let presenter = FilesListPresenter(
            viewController: viewController,
            moduleOutput: moduleOutput,
            files: files
        )
        viewController.output = presenter

        return viewController
    }
}
