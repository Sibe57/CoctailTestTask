//
//  ViewController.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 03.08.2022.
//

import AsyncDisplayKit

protocol SearchView {
    var presenter: AnyPresenter? { get set }
    func update(with coctails: [Coctail])
    func update(with error: String)
}

class CoctailViewController: ASDKViewController<ASDisplayNode>, SearchView {
    
    var presenter: AnyPresenter?
    
    private var coctails: [Coctail] = []
    private let searchBar: SearchField
    private let coctailsNode: CoctailCollectionNode
    
    override init() {
        coctailsNode = CoctailCollectionNode()
        searchBar = SearchField()
        
        super.init(node: ASDisplayNode())
        
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
                                  264) * 186 / 313
            print(self.view.safeAreaInsets.bottom)
            
            let stack = ASStackLayoutSpec(
                direction: .vertical,
                spacing: perfectSpacing,
                justifyContent: .start,
                alignItems: .center,
                children: [collection, self.searchBar]
            )
            return stack
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        searchBar.textField.delegate = self
        coctailsNode.delegate = self
        coctailsNode.dataSource = self
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.textField.resignFirstResponder()
    }
    
    func update(with coctails: [Coctail]) {
        self.coctails = coctails
        coctailsNode.reloadData()
        coctailsNode.isHidden = false
    }
    
    func update(with error: String) {
        print(error)
        coctailsNode.isHidden = true
    }
}

extension CoctailViewController: ASEditableTextNodeDelegate {
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode){
        presenter?.textFieldDidChange(
            text: searchBar.textField.attributedText?.string
        )
    }
}

extension CoctailViewController: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        coctails.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        guard coctails.count > indexPath.row else { return ASCellNode() }
        let coctail = coctails[indexPath.row]
        let cell =  CoctailCell(coctail: coctail)
        cell.cornerRadius = 8
        return cell
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let coctail = coctails[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.coctail = coctail
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.modalTransitionStyle = .coverVertical
        present(detailVC, animated: true)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
}



