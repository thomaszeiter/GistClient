//
//  FileInteractor.swift
//  GistClient
//
//  Created by Tanya Petrenko on 04.08.2022.
//

import Foundation
import DomainServices

final class FileInteractor {

    private let gistFilesService: GistFilesService
    weak var output: FileInteractorOutput?

    init(gistFilesService: GistFilesService) {
        self.gistFilesService = gistFilesService
    }
}

// MARK: - FileInteractorInput
extension FileInteractor: FileInteractorInput {

    func loadFileContent(_ file: File) {
        gistFilesService.loadGistFile(url: file.rawUrl) { [weak self] result in
            switch result {
            case .success(let content):
                let fileContent = FileContent(
                    fileName: file.filename,
                    content: content,
                    type: file.type,
                    language: file.language,
                    size: file.size)
                self?.output?.didLoadFileContentsWithSuccess(fileContent)
            case .failure(let error):
                self?.output?.didLoadFileContentsWithFailure(error)
            }
        }
    }
}
