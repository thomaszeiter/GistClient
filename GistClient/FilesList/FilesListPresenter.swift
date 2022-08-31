//
//  FilesListPresenter.swift
//  GistClient
//
//  Created by Tanya Petrenko on 12.08.2022.
//

import Foundation
import DomainServices

protocol FilesListModuleOutput: AnyObject {

    func didSelectFile(_ file: File)
}

class FilesListPresenter {

    private weak var viewController: FilesListViewControllerInput?
    private let moduleOutput: FilesListModuleOutput?
    private let files: [File]

    init(viewController: FilesListViewControllerInput,
         moduleOutput: FilesListModuleOutput,
         files: [File]
    ) {
        self.viewController = viewController
        self.moduleOutput = moduleOutput
        self.files = files
    }
}

extension FilesListPresenter {

    private func makeViewObjects() -> [FileListViewObject] {
        files.map { FileListViewObject(fileName: $0.filename) }
    }
}

extension FilesListPresenter: FilesListViewControllerOutput {

    func viewDidLoad() {
        viewController?.updateFiles(makeViewObjects())
    }

    func didSelectCell(at index: Int) {
        moduleOutput?.didSelectFile(files[index])
    }
}
