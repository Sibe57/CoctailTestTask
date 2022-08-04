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
    var searchTimer: Timer?
    
    func update(with users: [Coctail]) {
        
    }
    
    func update(with error: String) {
        
    }
    
    var presenter: AnyPresenter?
    
    var titleNode = ASTextNode()
    
    let coctails: [Coctail] = []
    
    private let searchBar: SearchField
    private let coctailsNode: CoctailCollectionNode
    
    override init() {
        let node = ASDisplayNode()
        self.coctailsNode = CoctailCollectionNode(coctails: coctails)
        searchBar = SearchField()
        
        super.init(node: node)
        node.backgroundColor = .yellow
        self.node.automaticallyManagesSubnodes = true
        self.node.layoutSpecBlock = {_,_ in
            let collection = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), child: self.coctailsNode)
            let stac = ASStackLayoutSpec(direction: .vertical,
                                         spacing: 23,
                                         justifyContent: .start,
                                         alignItems: .start,
                                         children: [collection, self.searchBar])
            return stac
        }
    }
    
    private func fetchData(searchString: String) {
        NetwotkManager.fetchData(searchString: searchString) {
            guard let coctails = $0 else { return }
            self.coctailsNode.coctails = coctails
            self.coctailsNode.reloadData()
        }
    }
    
    override func viewDidLoad() {
        searchBar.textField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchField: ASDisplayNode {
    var searchTimer: Timer?
    let textField: ASEditableTextNode
    let background: ASDisplayNode
    
    override init() {
        textField = ASEditableTextNode()
        textField.attributedText = NSMutableAttributedString(string: "KLR:GJ:OIDFJG:LKDFJGL")
    
        background = ASDisplayNode()
        background.style.preferredSize = CGSize(width: 200, height: 28)
        background.backgroundColor = .gray
        
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let paddingTextField = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), child: textField)
        let mainStack = ASOverlayLayoutSpec(child: background, overlay: paddingTextField)
        
        
        
        return mainStack
    }
    
}
extension CoctailViewController: ASEditableTextNodeDelegate {
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode){
        
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchText), userInfo: searchBar.textField.attributedText?.string, repeats: false)
        
    }
    
    @objc func searchText() {
        let text = searchBar.textField.attributedText
        guard let text = text?.string else { return }
        fetchData(searchString: text)
        
         
    }
}



