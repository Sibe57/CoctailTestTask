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
    private var searchTimer: Timer?
    
    func update(with users: [Coctail]) {
        
    }
    
    func update(with error: String) {
        
    }
    
    var presenter: AnyPresenter?
    
    var titleNode = ASTextNode()
    
    private var coctails: [Coctail] = []
    
    private let searchBar: SearchField
    private let coctailsNode: CoctailCollectionNode
    
    override init() {
        let node = ASDisplayNode()
        self.coctailsNode = CoctailCollectionNode()
        searchBar = SearchField()
        
        super.init(node: node)
        node.backgroundColor = .white
        self.node.automaticallyManagesSubnodes = true
        self.node.layoutSpecBlock = {_,_ in
            self.searchBar.style.preferredSize = CGSize(width: self.view.frame.width, height: 28)
            
            let collection = ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
                child: self.coctailsNode)
            
            let perfectSpacing = (self.view.frame.height -
                                  self.view.safeAreaInsets.bottom -
                                  self.view.safeAreaInsets.top -
                                  250) * 196 / 367
            
            let stac = ASStackLayoutSpec(
                direction: .vertical,
                spacing: perfectSpacing,
                justifyContent: .start,
                alignItems: .center,
                children: [collection, self.searchBar]
            )
            return stac
        }
    }
    override func viewDidLoad() {
        searchBar.textField.delegate = self
        coctailsNode.delegate = self
        coctailsNode.dataSource = self
    }
    
    private func fetchData(searchString: String) {
        NetwotkManager.fetchData(searchString: searchString) {
            guard let coctails = $0 else { return }
            self.coctails = coctails
            self.coctailsNode.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension CoctailViewController: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        print(coctails.count)
        return coctails.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        guard coctails.count > indexPath.row else { return ASCellNode() }
        let coctail = coctails[indexPath.row]
        
        let cell =  CoctailCell(coctail: coctail)
        cell.cornerRadius = 8
        return cell
    }
}



