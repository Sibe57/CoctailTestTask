//
//  ViewController.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 03.08.2022.
//

import AsyncDisplayKit

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func update(with users: [Coctail])
    func update(with error: String)
}


class CoctailViewController: ASDKViewController<ASDisplayNode>, AnyView {
    func update(with users: [Coctail]) {
        
    }
    
    func update(with error: String) {
        
    }
    
    var presenter: AnyPresenter?
    
    var titleNode = ASTextNode()
    
    let coctails: [Coctail] = []
    
    private let coctailsNode: CoctailCollectionNode
    

    override init() {
        let node = ASDisplayNode()
        self.coctailsNode = CoctailCollectionNode(coctails: coctails)
        coctailsNode.reloadData()
        super.init(node: node)
        node.backgroundColor = .yellow
        self.node.automaticallyManagesSubnodes = true
        self.node.layoutSpecBlock = {_,_ in
            let collection = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), child: self.coctailsNode)
            
            return collection
        }
    }
    
    override func viewDidLoad() {
        NetwotkManager.fetchData(searchString: "martini") {
            guard let coctails = $0 else { return }
            self.coctailsNode.coctails = coctails
            print(coctails)
            self.coctailsNode.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



