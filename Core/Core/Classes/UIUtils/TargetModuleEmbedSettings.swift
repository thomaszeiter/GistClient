//
//  TargetModuleEmbedSettings.swift
//  Alamofire
//
//  Created by Tanya Petrenko on 09.09.2022.
//

import Foundation

public struct TargetModuleEmbedSettings {

    public let containerView: UIView
    public let viewController: UIViewController

    public init(containerView: UIView, viewController: UIViewController) {
        self.containerView = containerView
        self.viewController = viewController
    }
}
