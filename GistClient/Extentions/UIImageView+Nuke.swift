//
//  UIImageView+Nuke.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Nuke
import UIKit

extension UIImageView {

    func setImage(url: URL?) {
        Nuke.loadImage(with: url, into: self)
    }
}
