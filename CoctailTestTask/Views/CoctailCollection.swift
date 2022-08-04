//
//  CoctailCollection.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

class CoctailCollectionNode: ASCollectionNode, ASCollectionDataSource, ASCollectionDelegate {
    var coctails: [Coctail]
    
    init(coctails: [Coctail]) {
        
        self.coctails = coctails
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4

        
        super.init(frame: .zero, collectionViewLayout: layout, layoutFacilitator: nil)
        
        self.style.width = ASDimension(unit: .fraction, value: 1)
        self.style.height = ASDimension(unit: .points, value: 200)
        self.delegate = self
        self.dataSource = self
        
        self.view.showsVerticalScrollIndicator = false
    }
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        print(coctails.count)
        return coctails.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        guard coctails.count > indexPath.row else { return ASCellNode() }
        let coctail = coctails[indexPath.row]
        
        let cell =  CoctailCell(coctail: coctail)
        cell.cornerRadius = 8
        return cell
    }
}
