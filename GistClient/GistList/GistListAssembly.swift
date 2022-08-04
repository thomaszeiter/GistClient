//
//  GistListAssembly.swift
//  GistClient
//
//  Created by Tanya Petrenko on 04.08.2022.
//

import Foundation
import UIKit

class GistListAssembly {

    func buildGistListModule() -> UIViewController {
        let navigationController = UINavigationController()

        let viewController = GistListViewController()
        let interactor = GistListInteractor()
        let presenter = GistListPresenter(viewController: viewController,
                                          interactor: interactor)
        viewController.presenter = presenter
        interactor.presenter = presenter

        navigationController.pushViewController(viewController, animated: false)
        return navigationController
    }

}
