//
//  CoctailCell.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

final class CoctailCell: ASCellNode {
    private let coctail: Coctail
    
    private let titleNode: ASTextNode
    
    init(coctail: Coctail) {
        self.coctail = coctail
        titleNode = ASTextNode()
    
        super.init()
        
        self.automaticallyManagesSubnodes = true
        setupText()
    }
    
    private func setupText() {
        let text = NSMutableAttributedString(string: coctail.strDrink)
        text.addAttribute(.foregroundColor, value: UIColor.white,
                          range: NSRange(0..<text.length))
        text.addAttribute(.font,
                          value: UIFont.systemFont(ofSize: 15, weight: .bold),
                          range: NSRange(0..<text.length))
        titleNode.attributedText = text
        titleNode.backgroundColor = #colorLiteral(red: 0.8110429645, green: 0.8110429049, blue: 0.8110428452, alpha: 1)
        titleNode.textContainerInset = UIEdgeInsets(top: 4, left: 16,
                                                    bottom: 4, right: 16)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASWrapperLayoutSpec(layoutElement: titleNode)
    }
}

