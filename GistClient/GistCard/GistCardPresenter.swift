//
//  GistCardPresenter.swift
//  GistClient
//
//  Created by Tanya Petrenko on 02.08.2022.
//

import Foundation

protocol GistCardInput: AnyObject {

    func getFiles()

}

class GistCardPresenter {

    private weak var viewController: GistCardViewControllerOutput?
    private let networkService = NetworkService()
    private let files: [String: File]

    init(viewController: GistCardViewControllerOutput, files: [String: File]) {
        self.viewController = viewController
        self.files = files
    }

}

extension GistCardPresenter: GistCardInput {

    func getFiles() {
        viewController?.updateState(.loading)
        if files.count == 1 && !files.isEmpty {
            guard let file = files.values.first else { return }
            networkService.getFileContentRawString(url: file.rawUrl) { result in
                switch result {
                case .success(let content):
                    self.viewController?.updateState(.normal)
                    let item = FileListItem(filename: file.filename, content: content)
                    self.viewController?.updateItems([item])
                case .failure(let error):
                    self.viewController?.updateState(.error(message: error.localizedDescription))
                }
            }

        } else if files.count > 1 && !files.isEmpty {
            guard let file = files.values.first else { return }
            networkService.getFileContentRawString(url: file.rawUrl) { result in
                switch result {
                case .success(let content):
                    let item = FileListItem(filename: file.filename, content: content)
                    let restOfFiles = self.files.values
                        .filter { $0.filename != file.filename }
                        .map { FileListItem(filename: $0.filename, content: nil) }
                    let items = [item] + restOfFiles
                    self.viewController?.updateState(.normal)
                    self.viewController?.updateItems(items)
                case .failure(let error):
                    self.viewController?.updateState(.error(message: error.localizedDescription))
                }
            }
        } else {
            viewController?.updateState(.error(message: "No files to represent, check your internet connection"))
        }
    }

}
