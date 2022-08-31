//
//  AppDependencyResolver.swift
//  GistClient
//
//  Created by Tanya Petrenko on 08.08.2022.
//

import UIKit
import Core
import DomainServices

final class AppDependencyResolver {

    private var dependenciesStorage: [String: Any] = [:]
    private let recursiveLock = NSRecursiveLock()

    private func resolveSingleton<T>(key: String = #function, resolve: () -> T) -> T {
        recursiveLock.lock()
        defer {
            recursiveLock.unlock()
        }
        if dependenciesStorage[key] == nil {
            dependenciesStorage[key] = resolve()
        }
        // swiftlint:disable:next force_cast
        return dependenciesStorage[key] as! T
    }
}

// MARK: - Core Services
extension AppDependencyResolver {

    var networkService: NetworkService {
        resolveSingleton { NetworkServiceFactory().buildNetworkService() }
    }
}

// MARK: - Domain Services
extension AppDependencyResolver {

    var gistsService: GistsService {
        DomainServicesFactory().buildGistsService()
    }

    var gistFilesService: GistFilesService {
        DomainServicesFactory().buildGistFilesService()
    }

    var syntaxHighlightingService: SyntaxHighlightService {
        SyntaxHighlightServiceFactory().buildSyntaxHighlightService()
    }
}

// MARK: - Formatters
extension AppDependencyResolver {

    var gistListDateFormatter: DateFormatter {
        resolveSingleton {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MM yy"
            return dateFormatter
        }
    }
}

// MARK: - GistListModule
extension AppDependencyResolver {

    func buildGistListModule(moduleOutput: GistListModuleOutput) -> UIViewController {
        let gistListAssembly = GistListAssembly(
            gistService: gistsService,
            dateFormatter: gistListDateFormatter,
            moduleOutput: moduleOutput
        )

        return gistListAssembly.buildGistListModule()
    }
}

// MARK: - GistCardModule
extension AppDependencyResolver {

    func buildFileModule(file: File) -> UIViewController {
        let fileAssembly = FileAssembly(
            gistFilesService: gistFilesService,
            file: file,
            syntaxHighlightingService: syntaxHighlightingService)
        return fileAssembly.buildFileModule()
    }
}

// MARK: - GistCardContainerModule
extension AppDependencyResolver {

    func buildGistCardModule(with gistId: String, moduleOutput: GistCardModuleOutput) -> UIViewController {
        let gistCardAssembly = GistCardAssembly(
            gistsService: gistsService,
            gistFilesService: gistFilesService,
            gistId: gistId,
            moduleOutput: moduleOutput
        )
        return gistCardAssembly.buildGistCardModule()
    }
}

// MARK: - GistCardFilesListModule
extension AppDependencyResolver {

    func buildFilesListModule(files: [File], moduleOutput: FilesListModuleOutput) -> UIViewController {
        let filesListAssembly = FilesListAssembly(files: files, moduleOutput: moduleOutput)
        return filesListAssembly.buildFilesListModule()
    }
}
