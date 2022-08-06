//
//  DetailViewController.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

protocol DetailView {
    
}

class DetailViewController: ASDKViewController<ASDisplayNode>, DetailView {
    
    var coctail: Coctail!
    
    private let image: ASNetworkImageNode
    private let titleNode: ASTextNode
    
    
    override init() {
        titleNode = ASTextNode()
        titleNode.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 20)
        titleNode.backgroundColor = .white
        
        image = ASNetworkImageNode()
        image.backgroundColor = #colorLiteral(red: 0.8110429645, green: 0.8110429049, blue: 0.8110428452, alpha: 1)
        image.cornerRadius = 20
        
        super.init(node: ASDisplayNode())
        
        node.automaticallyManagesSubnodes = true
        
        self.node.layoutSpecBlock = { [unowned self] _, _ in
            
            image.style.preferredSize = CGSize(width: node.frame.width,
                                               height: node.frame.height / 2)
            
            let stack = ASStackLayoutSpec(
                direction: .vertical, spacing: -36, justifyContent: .end,
                alignItems: .stretch, children: [image, titleNode]
            )
            return stack
        }
    }
    
    override func viewDidLoad() {
        node.backgroundColor = .clear
        setImageDownloading()
        setTextLabel()
    }
    
    private func setImageDownloading() {
        let url = coctail.strDrinkThumb.replacingOccurrences(of: "\\", with: "")
        image.url = URL(string: url)
    }
    
    private func setTextLabel() {
        let text = NSMutableAttributedString(string: coctail.strDrink)
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .semibold), range: NSRange(0..<text.length))
        titleNode.attributedText = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
}
