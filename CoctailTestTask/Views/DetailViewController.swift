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
    var coctail: Coctail!
    
    override init() {
        image = ASNetworkImageNode()
        super.init(node: ASDisplayNode())
        node.backgroundColor = .clear
        image.backgroundColor = .white
        node.automaticallyManagesSubnodes = true
        self.node.layoutSpecBlock = {_, _ in
            return ASWrapperLayoutSpec(layoutElement: self.image)
        }
    }
    
    override func viewDidLoad() {
        let url = coctail.strDrinkThumb.replacingOccurrences(of: "\\", with: "")
        print("iloveURL" + url)
        image.url = URL(string: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
}
