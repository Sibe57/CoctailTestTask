//
//  SearchField.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

class SearchField: ASDisplayNode {
    
    let textField: ASEditableTextNode
    let background: ASDisplayNode
    
    override init() {
        textField = ASEditableTextNode()
        let placeholder = NSMutableAttributedString(string: "Coctail name")
        placeholder.addAttribute(
            .foregroundColor,
            value: UIColor(red: 0.769,
                           green: 0.769,
                           blue: 0.769,
                           alpha: 1),
            range: NSRange(0..<placeholder.length)
        )
        textField.attributedPlaceholderText = placeholder
    
        background = ASDisplayNode()
        background.backgroundColor = .white
        
        super.init()
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        createShadow()
    }
    
    private func setTextField() {
        let placeholder = NSMutableAttributedString(string: "Coctail name")
        placeholder.addAttribute(.foregroundColor,
                                 value: UIColor(red: 0.769,
                                                green: 0.769,
                                                blue: 0.769,
                                                alpha: 1),
                                 range: NSRange(0..<placeholder.length))
        textField.attributedPlaceholderText = placeholder
    }
    
    private func createShadow() {
        background.cornerRadius = 10
        background.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        background.shadowOpacity = 1
        background.shadowRadius = 16
        background.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let paddingTextField = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
            child: textField
        )
        
        let centerTextField = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: .minimumXY,
            child: paddingTextField
        )
        
        let mainStack = ASOverlayLayoutSpec(
            child: background, overlay: centerTextField
        )
        
        let mainStackPadding = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
            child: mainStack
        )
        return mainStackPadding
    }
    
}
