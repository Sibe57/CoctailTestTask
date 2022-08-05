//
//  CoctailCell.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

class CoctailCell: ASCellNode {
    private let coctail: Coctail
    
    private let titleNode: ASTextNode
    
    init(coctail: Coctail) {
        self.coctail = coctail
        titleNode = ASTextNode()
        let text = NSMutableAttributedString(string: coctail.strDrink)
        text.addAttribute(.foregroundColor, value: UIColor.white,
                          range: NSRange(0...text.length - 1))
        text.addAttribute(.font,
                          value: UIFont.systemFont(ofSize: 15, weight: .bold),
                          range: NSRange(0...text.length - 1))
        titleNode.attributedText = text
        titleNode.backgroundColor = #colorLiteral(red: 0.8110429645, green: 0.8110429049, blue: 0.8110428452, alpha: 1)
        titleNode.textContainerInset = UIEdgeInsets(top: 4, left: 16,
                                                    bottom: 4, right: 16)
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASWrapperLayoutSpec(layoutElement: titleNode)
    }
}

