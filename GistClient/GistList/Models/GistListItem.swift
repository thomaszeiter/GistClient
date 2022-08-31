//
//  GistListItem.swift
//  NNN
//
//  Created by Tanya Petrenko on 01.08.2022.
//

import Foundation
import UIKit

struct GistListItem {

    let id: String
    let userAvatarUrl: URL
    let title: NSAttributedString
    let createdAt: NSAttributedString?
    let description: NSAttributedString?
    let numberOfFiles: NSAttributedString
}
