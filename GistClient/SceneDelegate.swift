//
//  SceneDelegate.swift
//  GistClient
//
//  Created by Tanya Petrenko on 31.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var coordinator = AppCoordinator()

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window = window
        self.window?.windowScene = windowScene
        coordinator.delegate = self
        coordinator.start()
    }
}

extension SceneDelegate: AppCoordinatorDelegate {

    func didBuildRootViewController(viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
