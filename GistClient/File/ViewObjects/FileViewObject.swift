//
//  FileViewObject.swift
//  GistClient
//
//  Created by Tanya Petrenko on 02.08.2022.
//

import Foundation

struct FileViewObject {
    let filename: String
    let content: NSAttributedString?
    let type: FileListItemType
}

enum FileListItemType {
    case file
    case error
}
