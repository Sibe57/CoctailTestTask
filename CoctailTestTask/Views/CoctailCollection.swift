//
//  CoctailCollection.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

class CoctailCollectionNode: ASCollectionNode {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8

        super.init(frame: .zero, collectionViewLayout: layout, layoutFacilitator: nil)
        
        self.style.width = ASDimension(unit: .fraction, value: 1)
        self.style.height = ASDimension(unit: .points, value: 250)
        self.view.showsVerticalScrollIndicator = false
    }
}

