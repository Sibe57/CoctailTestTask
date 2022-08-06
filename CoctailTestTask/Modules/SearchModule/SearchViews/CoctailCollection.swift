//
//  CoctailCollection.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

final class CoctailCollectionNode: ASCollectionNode {
    
    init() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout, layoutFacilitator: nil)
        setupCollectionSize()
    }
    
    private func setupCollectionSize() {
        style.width = ASDimension(unit: .fraction, value: 1)
        style.height = ASDimension(unit: .points, value: 264)
        view.showsVerticalScrollIndicator = false
    }
}


final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        minimumLineSpacing = 8
        minimumInteritemSpacing = 10

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}
