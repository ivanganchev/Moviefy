//
//  CategoryCollectionViewFlowLayoutDelegate.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.09.21.
//

import Foundation
import UIKit

class CategoryCollectionViewFlowLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    let interItemSpacing: CGFloat = 5.0
    let lineSpacingForSection: CGFloat = 5.0
    let itemsInRow: CGFloat = 3.0
    let itemsInColumn : CGFloat = 4.0

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width / self.itemsInRow - self.interItemSpacing
        let yourHeight = collectionView.bounds.height / self.itemsInColumn
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.interItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.lineSpacingForSection
    }
}
