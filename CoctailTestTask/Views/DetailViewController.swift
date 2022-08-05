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
    
    let image: ASNetworkImageNode
    let titleNode: ASTextNode
//    let titleBackground: ASDisplayNode
    var coctail: Coctail!
    
    override init() {
        titleNode = ASTextNode()
        titleNode.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 20)
        titleNode.backgroundColor = .white
        image = ASNetworkImageNode()
        super.init(node: ASDisplayNode())
        node.backgroundColor = .clear
        image.backgroundColor = .white
        image.style.preferredSize = CGSize(width: node.frame.width, height: node.frame.height / 2)
        image.cornerRadius = 20
        
        node.automaticallyManagesSubnodes = true
        self.node.layoutSpecBlock = {_, _ in
            self.image.style.preferredSize = CGSize(width: self.node.frame.width, height: self.node.frame.height / 2)
            let spacing = -1 * self.titleNode.frame.height
            print(spacing)
            let stack = ASStackLayoutSpec(direction: .vertical, spacing: -36, justifyContent: .end, alignItems: .stretch, children: [self.image, self.titleNode])
        
            return stack
        }
    }
    
    override func viewDidLoad() {
        let url = coctail.strDrinkThumb.replacingOccurrences(of: "\\", with: "")
        print("iloveURL" + url)
        image.url = URL(string: url)
        let text = NSMutableAttributedString(string: coctail.strDrink)
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .semibold), range: NSRange(0..<text.length))
        titleNode.attributedText = text
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
}
