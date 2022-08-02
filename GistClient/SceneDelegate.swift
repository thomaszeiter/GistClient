//
//  SceneDelegate.swift
//  NNN
//
//  Created by Tanya Petrenko on 31.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = makeInitialScreen()
        window?.makeKeyAndVisible()
    }

    private func makeInitialScreen() -> UIViewController {
        let navigationController = UINavigationController()

        let viewController = GistListViewController()
        let presenter = GistListPresenter(viewController: viewController)
        viewController.presenter = presenter

        navigationController.pushViewController(viewController, animated: false)
        return navigationController
    }

}

