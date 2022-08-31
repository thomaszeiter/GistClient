//
//  AppCoordinator.swift
//  GistClient
//
//  Created by Tanya Petrenko on 08.08.2022.
//

import Core
import DomainServices
import SnapKit
import UIKit

protocol AppCoordinatorDelegate: AnyObject {

    func didBuildRootViewController(viewController: UIViewController)
}

final class AppCoordinator {

    private let deps = AppDependencyResolver()
    weak var delegate: AppCoordinatorDelegate?
    private var routingContext: UINavigationController?

    func start() {
        let gistListModule = deps.buildGistListModule(moduleOutput: self)
        let navigationController = UINavigationController()
        navigationController.pushViewController(gistListModule, animated: false)
        routingContext = navigationController
        delegate?.didBuildRootViewController(viewController: navigationController)
    }
}

extension AppCoordinator {

    func setModuleAsChild(targetModuleEmbedSettings: TargetModuleEmbedSettings, embeddingModule: UIViewController) {
        targetModuleEmbedSettings.viewController.embed(child: embeddingModule, in: targetModuleEmbedSettings.containerView)
    }
}

// MARK: - GistListModuleOutput
extension AppCoordinator: GistListModuleOutput {

    func didOpenGist(by id: String) {
        let gistCardModule = deps.buildGistCardModule(with: id, moduleOutput: self)
        routingContext?.pushViewController(gistCardModule, animated: true)
    }
}

extension AppCoordinator: GistCardModuleOutput {

    func didLoadGistWithOneFile(_ file: File, inModule module: GistCardModuleInput) {
        let fileModule = deps.buildFileModule(file: file)
        guard let targetModuleEmbedSettings = module.filesModuleEmbedSettings else { return }
        setModuleAsChild(targetModuleEmbedSettings: targetModuleEmbedSettings, embeddingModule: fileModule)
    }

    func didLoadGistWithMultipleFiles(_ files: [File], inModule module: GistCardModuleInput) {
        let filesListModule = FilesListAssembly(files: files, moduleOutput: self).buildFilesListModule()
        guard let targetModuleEmbedSettings = module.filesModuleEmbedSettings else { return }
        setModuleAsChild(targetModuleEmbedSettings: targetModuleEmbedSettings, embeddingModule: filesListModule)
    }
}

extension AppCoordinator: FilesListModuleOutput {

    func didSelectFile(_ file: File) {
        let fileModule = deps.buildFileModule(file: file)
        routingContext?.pushViewController(fileModule, animated: true)
    }
}
