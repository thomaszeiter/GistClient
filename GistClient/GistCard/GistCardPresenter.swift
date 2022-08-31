//
//  GistCardPresenter.swift
//  GistClient
//
//  Created by Tanya Petrenko on 12.08.2022.
//

import Foundation
import Core
import DomainServices

protocol GistCardModuleInput {

    var filesModuleEmbedSettings: TargetModuleEmbedSettings? { get }
}

protocol GistCardModuleOutput: AnyObject {

    func didLoadGistWithOneFile(_ file: File, inModule module: GistCardModuleInput)
    func didLoadGistWithMultipleFiles(_ files: [File], inModule module: GistCardModuleInput)
}

protocol GistCardInteractorInput: AnyObject {

    func loadGist(by id: String)
}

protocol GistCardInteractorOutput: AnyObject {

    func didGistLoadWithSuccess(_ gist: Gist)
    func didGistLoadWithFailure(_ error: Error)
}

class GistCardPresenter {

    private weak var viewController: GistCardViewControllerInput?
    private weak var moduleOutput: GistCardModuleOutput?
    let interactor: GistCardInteractorInput

    private let gistId: String

    init(viewController: GistCardViewControllerInput,
         interactor: GistCardInteractorInput,
         gistId: String,
         moduleOutput: GistCardModuleOutput
    ) {
        self.viewController = viewController
        self.interactor = interactor
        self.gistId = gistId
        self.moduleOutput = moduleOutput
    }
}

extension GistCardPresenter {

    private func loadGist() {
        interactor.loadGist(by: gistId)
    }
}

extension GistCardPresenter: GistCardViewControllerOutput {

    func viewDidLoad() {
        viewController?.updateState(.loading)
        loadGist()
    }

    func didTapAtTryAgainButton() {
        viewController?.updateState(.loading)
        loadGist()
    }
}

extension GistCardPresenter: GistCardInteractorOutput {

    func didGistLoadWithSuccess(_ gist: Gist) {
        guard !gist.files.isEmpty else {
            viewController?.updateState(.error(message: "No files in gist yet"))
            return
        }

        if gist.files.count == 1 {
            let file = gist.files.first!.value
            moduleOutput?.didLoadGistWithOneFile(file, inModule: self)
        } else {
            let files = gist.files
                .map { $0.value }
                .sorted { $0.filename > $1.filename }
            moduleOutput?.didLoadGistWithMultipleFiles(files, inModule: self)
        }
    }

    func didGistLoadWithFailure(_ error: Error) {
        viewController?.updateState(.error(message: error.localizedDescription))
    }
}

extension GistCardPresenter: GistCardModuleInput {

    var filesModuleEmbedSettings: TargetModuleEmbedSettings? {
        viewController?.filesModuleEmbedSettings()
    }
}
