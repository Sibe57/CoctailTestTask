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
    func changeAtrivitiIndicatorState(toStartAnimating: Bool)
}

class CoctailViewController: ASDKViewController<ASDisplayNode>, SearchView {
    
    var presenter: AnyPresenter?
    
    private var coctails: [Coctail] = []
    
    private let searchBar: SearchField
    private let coctailsNode: CoctailCollectionNode
    
    private let activityIndicatorNode: ASDisplayNode
    private let activityIndicator: UIActivityIndicatorView
    
    lazy var blurredView: UIView = {
            let containerView = UIView()
            let blurEffect = UIBlurEffect(style: .light)
            let customBlurEffectView = CustomVisualEffectView(effect: blurEffect,
                                                              intensity: 0.08)
            customBlurEffectView.frame = self.view.bounds
            return customBlurEffectView
        }()
    
    override init() {
        coctailsNode = CoctailCollectionNode()
        searchBar = SearchField()
        activityIndicatorNode = ASDisplayNode()
        activityIndicatorNode.backgroundColor = .red
        activityIndicator = UIActivityIndicatorView()
        activityIndicatorNode.view.addSubview(activityIndicator)
        super.init(node: ASDisplayNode())
        
        node.backgroundColor = .white
        node.automaticallyManagesSubnodes = true
        
        node.layoutSpecBlock = {[unowned self] _,_ in
            
            activityIndicatorNode.style.layoutPosition = CGPoint(
                x: view.frame.midX - 10, y: 48
            )
            activityIndicatorNode.style.preferredSize = CGSize(
                width: 0, height: 0
            )
            searchBar.style.preferredSize = CGSize(
                width: view.frame.width, height: 28
            )
            
            let indicatorPos = ASAbsoluteLayoutSpec(children: [activityIndicatorNode])
            let coctailsCollectionPos = ASOverlayLayoutSpec(
                child: coctailsNode,
                overlay: indicatorPos
            )
        
            let insets = ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
                child: coctailsCollectionPos)
            
            let perfectSpacing = (view.frame.height -
                                  view.safeAreaInsets.bottom -
                                  view.safeAreaInsets.top -
                                  264) * 186 / 313
            
            let stack = ASStackLayoutSpec(
                direction: .vertical,
                spacing: perfectSpacing,
                justifyContent: .start,
                alignItems: .center,
                children: [insets, searchBar]
            )
            return stack
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.textField.delegate = self
        coctailsNode.delegate = self
        coctailsNode.dataSource = self
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.textField.resignFirstResponder()
    }
    
    func update(with coctails: [Coctail]) {
        self.coctails = coctails
        coctailsNode.reloadData()
        coctailsNode.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func update(with error: String) {
        print(error)
        coctailsNode.isHidden = true
    }
    
    func changeAtrivitiIndicatorState(toStartAnimating: Bool) {
        toStartAnimating
        ? activityIndicator.startAnimating()
        : activityIndicator.stopAnimating()
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
        presenter?.cellDidTapped(with: coctails[indexPath.row])
        searchBar.textField.resignFirstResponder()
        let detailVC = DetailViewController()
        detailVC.coctail = coctails[indexPath.row]
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.modalTransitionStyle = .coverVertical
        present(detailVC, animated: true)
        
    }
}



