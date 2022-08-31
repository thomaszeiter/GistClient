//
//  FilePresenter.swift
//  GistClient
//
//  Created by Tanya Petrenko on 02.08.2022.
//

import UIKit
import Core
import DomainServices

protocol FileInteractorInput: AnyObject {

    func loadFileContent(_ file: File)
}

protocol FileInteractorOutput: AnyObject {

    func didLoadFileContentsWithSuccess(_ contents: FileContent)
    func didLoadFileContentsWithFailure(_ error: Error)
}

final class FilePresenter {

    private weak var viewController: FileViewControllerInput?
    let interactor: FileInteractorInput
    private let syntaxHighlightingService: SyntaxHighlightService

    private let file: File

    init(viewController: FileViewControllerInput,
         file: File,
         interactor: FileInteractorInput,
         syntaxHighlightingService: SyntaxHighlightService
    ) {
        self.viewController = viewController
        self.file = file
        self.interactor = interactor
        self.syntaxHighlightingService = syntaxHighlightingService
    }
}

// MARK: - Private
extension FilePresenter {

    private func loadFileContent() {
        interactor.loadFileContent(file)
    }

    private func makeFileListItems(contents: FileContent, completion: @escaping ([FileViewObject]) -> Void) {
        syntaxHighlightingService
            .highlightSyntax(code: contents.content, language: contents.language) { highlightedContent in
                let fileItem = FileViewObject(
                    filename: contents.fileName,
                    content: highlightedContent,
                    type: .file
                )
                completion([fileItem])
            }
    }
}

// MARK: - FileViewControllerOutput
extension FilePresenter: FileViewControllerOutput {

    func viewDidLoad() {
        viewController?.updateState(.loading)
        loadFileContent()
    }

    func didTapAtTryAgainButton() {
        viewController?.updateState(.loading)
        loadFileContent()
    }
}

// MARK: - FileInteractorOutput
extension FilePresenter: FileInteractorOutput {

    func didLoadFileContentsWithSuccess(_ contents: FileContent) {
        viewController?.updateState(.normal)
        makeFileListItems(contents: contents) { [weak self] viewObjects in
            self?.viewController?.updateItems(viewObjects)
        }
    }

    func didLoadFileContentsWithFailure(_ error: Error) {
        viewController?.updateState(.error(message: error.localizedDescription))
    }
}
