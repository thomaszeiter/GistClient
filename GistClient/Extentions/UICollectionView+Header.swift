//
//  UICollectionView+Header.swift
//  GistClient
//
//  Created by Tanya Petrenko on 11.08.2022.
//

import UIKit

extension UICollectionView {

    func dequeueReusableHeaderView(id: String, for indexPath: IndexPath) -> UICollectionReusableView {
        dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: id,
            for: indexPath)
    }
}
