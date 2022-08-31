//
//  UIViewController+Child.swift
//  Core
//
//  Created by Tanya Petrenko on 09.09.2022.
//

import SnapKit
import UIKit

extension UIViewController {

    public func embed(child viewController: UIViewController, in containerView: UIView) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        viewController.didMove(toParent: self)
    }
}
