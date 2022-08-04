//
//  CoctailCell.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

class CoctailCell: ASCellNode {
    let coctail: Coctail
    
    let titleNode: ASTextNode
    
    init(coctail: Coctail) {
        self.coctail = coctail
        titleNode = ASTextNode()
        let text = NSMutableAttributedString(string: coctail.strDrink)
        text.addAttribute(.foregroundColor, value: UIColor.white,
                          range: NSRange(0...text.length - 1))
        text.addAttribute(.font,
                          value: UIFont.systemFont(ofSize: 12, weight: .bold),
                          range: NSRange(0...text.length - 1))
        titleNode.attributedText = text
        titleNode.backgroundColor = .gray
        titleNode.textContainerInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        titleNode.cornerRadius = 8
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: titleNode)
    }
}
