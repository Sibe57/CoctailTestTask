//
//  SearchField.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

final class SearchField: ASDisplayNode {
    
    let textField: ASEditableTextNode
    private let background: ASDisplayNode
    
    private var initialFrame: CGRect?
    
    private var keyboardIsShowing: Bool = false
    private var keyboardHeight: CGFloat = 0
    
    override init() {
        textField = ASEditableTextNode()
        background = ASDisplayNode()
        
        super.init()
        
        self.automaticallyManagesSubnodes = true
        setTextField()
    }
    
    override func didLoad() {
        createShadow()
        setKeyboardNotifications()
        setGestureRecognizer()
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
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        background.cornerRadius = keyboardIsShowing ? 0 : 8
        let scaleXfactor = 1 + (32 / (supernode!.frame.width - 32))
        let transform = CGAffineTransform(scaleX: keyboardIsShowing ? scaleXfactor : 1, y: 1)
        
        if keyboardIsShowing {
            view.frame.origin.y = supernode!.frame.maxY - keyboardHeight - view.frame.height
        } else {
            view.frame.origin.y = initialFrame?.minY ?? view.frame.origin.y
        }
        background.view.transform = transform
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
        background.backgroundColor = .white
        background.cornerRadius = 10
        background.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        background.shadowOpacity = 1
        background.shadowRadius = 16
        background.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setGestureRecognizer() {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundDidTapped)
        )
        
        background.view.addGestureRecognizer(gesture)
    }
    
    @objc func backgroundDidTapped() {
        textField.becomeFirstResponder()
    }
    
    private func setKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardIsShowing = true
        if initialFrame == nil {
            initialFrame = self.view.frame
        }
        guard let keyboardFrame: NSValue =
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue else { return }
        keyboardHeight = keyboardFrame.cgRectValue.height
        
        transitionLayout(withAnimation: true, shouldMeasureAsync: false)
    }
    
    @objc func keyboardWillHide() {
        keyboardIsShowing = false
        transitionLayout(withAnimation: true, shouldMeasureAsync: false)
    }
}
